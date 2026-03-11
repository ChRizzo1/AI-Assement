from flask_sqlalchemy import SQLAlchemy
from server import app

# Configure the database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///ai_assessment.db'  # Replace with GCP Cloud SQL URI later
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define the database models
class Assessment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    size = db.Column(db.String(50), nullable=False)
    data_readiness = db.Column(db.Integer, nullable=False)
    governance = db.Column(db.String(10), nullable=False)
    strategy_maturity = db.Column(db.Integer, nullable=False)
    technical_expertise = db.Column(db.String(10), nullable=False)
    score = db.Column(db.Integer, nullable=False)
    notes = db.Column(db.Text, nullable=False)

class Contact(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    message = db.Column(db.Text, nullable=False)

# Initialize the database
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        print("Database tables created.")