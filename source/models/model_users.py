from .entities.users import Users

class ModelUsers():
    @classmethod
    def login(self, db, user):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_verify_identity(%s, %s)", (user.username, user.password))
            row = cursor.fetchone()
            if row[0] != None:
                return Users(row[0], row[1], row[2], row[4], row[3], row[5], row[6], row[7], row[8])
            else:
                return None
        except Exception as ex:
            raise Exception(ex)
    
    @classmethod
    def get_user_by_id(self, db, id):
        try:
            cursor = db.connection.cursor()
            cursor.execute("SELECT * FROM flower_shop.users WHERE id = %s", (id))
            row = cursor.fetchone()
            if row != None:
                return Users(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
            else:
                return None
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def get_users(cls, db):
        try:
            sql_statement = """
                            SELECT * FROM flower_shop.users
                            """
            cursor = db.connection.cursor()
            cursor.execute(sql_statement)
            users = cursor.fetchall()
            return users
        except Exception as e:
            raise Exception(e)

    @classmethod
    def add_user(self, db, user):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_add_user(%s, %s, %s, %s, %s, %s, %s, %s)", (user.username, user.password, user.name, user.lastname, user.email, user.address, user.phone, user.userType))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def edit_user(self, db, user):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_edit_user(%s, %s, %s, %s, %s, %s, %s, %s, %s)", (user.id, user.username, user.password, user.name, user.lastname, user.email, user.address, user.phone, user.userType))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def delete_user(self, db, id):
        try:
            cursor = db.connection.cursor()
            cursor.execute("CALL sp_delete_user(%s)", (id))
            db.connection.commit()
        except Exception as ex:
            raise Exception(ex)