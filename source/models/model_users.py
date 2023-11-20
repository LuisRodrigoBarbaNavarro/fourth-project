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
