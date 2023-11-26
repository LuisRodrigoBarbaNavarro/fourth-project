from .entities.products import Products

class ModelProducts():
    
    @classmethod
    def add_product(self, db, product):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_add_product(%s, %s, %s, %s)", (product.name, product.description, product.price, product.url_image))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)
    
    @classmethod
    def edit_product(self, db, product):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_edit_product(%s, %s, %s, %s, %s)", (product.id, product.name, product.description, product.price, product.url_image))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def delete_product(self, db, id):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_delete_product(%s)", (id,))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)
    
    @classmethod
    def get_products(cls, db):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_get_products()")
            products = cursor.fetchall()
            return [Products(row[0], row[1], row[2], row[3], row[4]) for row in products]
        except Exception as ex:
            raise Exception(ex)
    
    @classmethod
    def get_products_by_id(self, db, id):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_get_products_by_id(%s)", (id,))
            row = cursor.fetchone()
            if row:
                return Products(row[0], row[1], row[2], row[3], row[4])
            else:
                return None
        except Exception as ex:
            raise Exception(ex)