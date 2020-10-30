from flask_restplus import Api
from apis.sample import namespace as sample

api = Api(title='Jenkins Learning', description = 'Wall of APIs that is used for learning jenkins')

api.add_namespace(sample)