from functools import wraps
from flask import Flask, abort, flash, redirect, render_template, request, url_for
from flask_login import LoginManager, current_user, login_user, logout_user, login_required
from flask_mysqldb import MySQL

from config import config

from models.model_users import ModelUsers
from models.model_products import ModelProducts

from models.entities.users import Users
from models.entities.products import Products

app = Flask(__name__)
db = MySQL(app)

login_manager_app = LoginManager(app)

# Authentication - Start

@app.route("/")
def index():
    return redirect("login")

@app.route("/login", methods=["GET", "POST"])
def login():
    if current_user.is_authenticated == False:
        if request.method == "POST":
            user = Users (
                0,
                request.form["usernameInput"],
                request.form["passwordInput"],
                "",
                "",
                "",
                "",
                "",
                ""
            )
            logged_user = ModelUsers.login(db, user)

            if logged_user is not None:
                if logged_user.user_type == 1 or logged_user.user_type == 0:
                    login_user(logged_user)
                    return redirect(url_for("dashboard"))
            else:
                flash("Usuario o contraseña incorrectos.")
                return render_template("auth/login.html")
        else:
            return render_template("auth/login.html")
    else:
        return redirect(url_for("dashboard"))

@app.route("/error")
def error():
    return render_template("auth/error.html")

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("login"))

@login_manager_app.user_loader
def load_user(id):
    return ModelUsers.get_user_by_id(db, id)

def admin_required(func):
    @wraps(func)
    def decorated_view(*args, **kwargs):
        if not current_user.is_authenticated or current_user.user_type != 1:
            abort(403, description="No tienes permisos para acceder a esta página.")
        return func(*args, **kwargs)
    return decorated_view

# Authentication - End

# Views - Start

@app.route("/dashboard")
@login_required
def dashboard():
    return render_template("public/dashboard.html")

@app.route("/products")
@login_required
@admin_required
def products():
    try:
        products = ModelProducts.get_products(db)
        return render_template("public/products-add.html", products=products)
    except Exception as e:
        raise Exception(e)

def validate_form(product) -> bool:
    if len(product.name) == 0:
        flash("Nombre no puede estar vacío.")
    if len(product.description) == 0:
        flash("Descripción no puede estar vacío.")
    if len(product.price) == 0:
        flash("Precio no puede estar vacío.")
    if float(product.price) < 0:
        flash("Precio no puede ser negativo.")
    return True

@app.route("/products/add", methods=["GET", "POST"])
@login_required
@admin_required
def add_product():
    if request.method == "POST":
        product = Products (
        request.form["nameInput"],
        request.form["descriptionInput"],
        request.form["priceInput"],
        request.form["imageInput"]
        )
        if validate_form(product):
            flash("Producto insertado correctamente.")
            ModelProducts.add_product(db, product, None)
        else:
            return render_template("public/products-add.html")
    return redirect(url_for("products"))

@app.route("/products/edit/<int:id>", methods=["GET", "POST"])
@login_required
@admin_required
def edit_product(id):
    if request.method == "POST":
        product = Products (
        request.form["nameInput"],
        request.form["descriptionInput"],
        request.form["priceInput"],
        request.form["imageInput"]
        )
        if validate_form(product):
            flash("Producto actualizado correctamente.")
            ModelProducts.edit_product(db, product, id)
        return redirect(url_for("products"))
    else:
        return render_template("public/products-edit.html", id=id, product=ModelProducts.get_product_by_id(db, id))

@app.route("/products/delete/<int:id>", methods=["GET", "POST"])
@login_required
@admin_required
def delete_product(id):
    if request.method == "POST":
        ModelProducts.delete_product(db, id)
        flash("Producto eliminado correctamente.")
        return redirect(url_for("products"))
    else:
        return render_template("public/products-delete.html", id=id)

@app.route("/users")
@login_required
@admin_required
def users():
    try:
        return render_template("public/users-add.html")
    except Exception as e:
        raise Exception(e)
    
@app.route("/users/add", methods=["GET", "POST"])
@login_required
@admin_required
def add_user():
    pass
    

@app.route("/shop")
@login_required
def shop():
    try:
        products = ModelProducts.get_products(db)
        return render_template("public/shop.html", products=products)
    except Exception as e:
        raise Exception(e)
    
@app.route("/shop/add/<int:id>", methods=["GET", "POST"])
@login_required
def add_to_cart(id):
    pass

@app.route("/about")
@login_required
def about():
    return render_template("public/about.html")

# Views - End

if __name__ == '__main__':
    app.config.from_object(config['development'])
    app.run()
