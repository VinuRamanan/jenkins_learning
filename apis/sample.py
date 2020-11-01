from flask_restplus import Namespace, Resource

namespace = Namespace('sample', description='Sample API to test Jenkins')

@namespace.route('/message/<string:name>')
class Message(Resource):
    @namespace.doc(description='Greetiings')
    def get(self, name):
        return 'Hello {}!'.format(name)