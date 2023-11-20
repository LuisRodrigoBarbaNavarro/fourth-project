from .entities.products import Products

class ModelProducts():
    @classmethod
    def add_product(cls, db, product, id=None):
        try:
            sql_statement = """
                            INSERT INTO flower_shop.products (name, description, price, url_image) VALUES (%s, %s, %s, %s)
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement, (product.name,
                            product.description, product.price, product.url_image))
            db.connection.commit()
            return cursor.lastrowid
        except Exception as e:
            raise Exception(e)

    @classmethod
    def edit_product(cls, db, product, id):
        try:
            sql_statement = """
                            UPDATE flower_shop.products SET name = %s, description = %s, price = %s, url_image = %s WHERE id = %s
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement, (product.name,
                            product.description, product.price, product.url_image, id))
            db.connection.commit()
            return cursor.lastrowid
        except Exception as e:
            raise Exception(e)
        
    @classmethod
    def delete_product(cls, db, id):
        try:
            sql_statement = """
                            DELETE FROM flower_shop.products WHERE id = %s
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement, (id,))
            db.connection.commit()
            return cursor.lastrowid
        except Exception as e:
            raise Exception(e)

    @classmethod
    def get_products(cls, db):
        try:
            sql_statement = """
                            SELECT * FROM flower_shop.products
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement)
            products = cursor.fetchall()
            return products
        except Exception as e:
            raise Exception(e)
        
    @classmethod
    def get_product_by_id(cls, db, id):
        try:
            sql_statement = """
                            SELECT * FROM flower_shop.products WHERE id = %s
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement, (id,))
            product = cursor.fetchone()
            return product
        except Exception as e:
            raise Exception(e)
