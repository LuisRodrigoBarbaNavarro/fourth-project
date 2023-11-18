from functools import wraps
from flask import Flask, abort, flash, redirect, render_template, request, url_for
from flask_login import LoginManager, current_user, login_user, logout_user, login_required
from mysql.connector import MySQLConnection

from config import config

from models.model_users import ModelUsers
from models.entities.users import Users

app = Flask(__name__)
db = MySQLConnection(app)

login_manager_app = LoginManager(app)

# Authentication - Start

@app.route("/")
def index():
    return redirect("login")

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user = Users(
            id=0,
            username=request.form["username"],
            password=request.form["password"],
            firstname="",
            lastname="",
            email="",
            physical_address="",
            user_type=0
        )
        logged_user = ModelUsers.login(db, user)

        if logged_user is not None:
            login_user(logged_user)
            if logged_user.user_type == 1 or logged_user.user_type == 0:
                return redirect(url_for("dashboard"))
        else:
            flash("Usuario o contraseña incorrectos.")
            return render_template("auth/login.html")
    else:
        return render_template("auth/login.html")

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
        if not current_user.is_authenticated or current_user.usertype != 1:
            abort(403, description="No tienes permisos para acceder a esta página.")
        return func(*args, **kwargs)
    return decorated_view

# Authentication - End

# Views - Start

@app.route("/dashboard")
@login_required
def dashboard():
    return render_template("dashboard.html")

# Views - End

if __name__ == '__main__':
    app.config.from_object(config['development'])
    app.run()
