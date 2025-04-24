# -*- coding: utf-8 -*-
from flask import Flask, request, jsonify, redirect
from flask_cors import CORS
import MySQLdb
from werkzeug.security import check_password_hash, generate_password_hash
from urllib.parse import quote
import logging
from decimal import Decimal
import os
import re
from itsdangerous import URLSafeSerializer
from prometheus_flask_exporter import PrometheusMetrics  # Import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)  # Inizializza PrometheusMetrics
app.secret_key = os.environ.get('SECRET_KEY', os.urandom(24))
app.logger.setLevel(logging.INFO)

# static information as metric
metrics.info('app_info', 'Application info', version='1.0.0') # Puoi aggiornare la versione

# More restrictive CORS configuration
CORS(app, resources={
    r"/*": {
        "origins": "http://worker1:31566",
        "methods": ["GET", "POST"],
        "allow_headers": ["Content-Type"],
        "supports_credentials": True
    }
})

# Database configuration with environment variables
DB_CONFIG = {
    'host': os.environ.get('MYSQL_HOST', 'mysql-service'),
    'user': os.environ.get('MYSQL_USER', 'root'),
    'password': os.environ.get('MYSQL_PASSWORD'),
    'database': os.environ.get('MYSQL_DB', 'bankdb')
}

URL_FRONTEND = 'http://worker1:31566'

# Email validation
EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')

# Aggiunto: Generatore/validatore di token
TOKEN_SECRET_KEY = os.environ.get('TOKEN_SECRET_KEY', 'default-insecure-key-change-me')
token_serializer = URLSafeSerializer(TOKEN_SECRET_KEY)

# Aggiungi all'inizio, dopo gli import
def check_config():
    if not DB_CONFIG['password']:
        raise ValueError("Database password not configured. Check DB_PASSWORD environment variable")

# Chiamalo prima del primo utilizzo del DB
check_config()

def get_db_connection():
    try:
        check_config()  # Verifica aggiuntiva
        conn = MySQLdb.connect(**DB_CONFIG)
        conn.autocommit(False)
        return conn
    except Exception as e:
        app.logger.error(f"DB connection failed. Config: {DB_CONFIG} (password hidden)")
        raise

def validate_input(data, fields):
    return all(data.get(field) for field in fields)

def sanitize_string(input_str):
    return input_str.strip() if input_str else None

def validate_token(token):
    """Verifica avanzata del token"""
    if not token:
        return False
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Verifica che il token sia decodificabile
        data = token_serializer.loads(token)
        user_id = data.get('user_id')
        if not user_id:
            return False

        # Verifica che l'utente esista ancora nel database
        cursor.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        if not cursor.fetchone():
            return False

        return True
    except:
        return False
    finally:
        if 'conn' in locals():
            conn.close()

#LOGIN
@app.route('/login', methods=['POST'])
def login():
    if not validate_input(request.form, ['email', 'password']):
        return redirect(f"{URL_FRONTEND}/index.html?error={quote('Email and password are required')}")

    try:
        email = sanitize_string(request.form['email'])
        password = request.form['password']

        if not EMAIL_REGEX.match(email):
            return redirect(f"{URL_FRONTEND}/index.html?error={quote('Invalid email format')}")

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT id, name, password FROM users WHERE email = %s",
            (email,)
        )
        user = cursor.fetchone()

        if not user or not check_password_hash(user[2], password):
            return redirect(f"{URL_FRONTEND}/index.html?error={quote('Invalid credentials')}")

        auth_token = token_serializer.dumps({'user_id': user[0]})
        return redirect(f"{URL_FRONTEND}/dashboard.html?token={quote(auth_token)}&name={quote(user[1])}")

    except Exception as e:
        app.logger.error(f"Login error: {str(e)}", exc_info=True)
        return redirect(f"{URL_FRONTEND}/index.html?error={quote('Server error')}")
    finally:
        if 'conn' in locals():
            conn.close()

@app.route('/dashboard')
def dashboard():
    token = request.args.get('token')
    if not validate_token(token):
        return redirect(f"{URL_FRONTEND}/index.html?error={quote('Invalid session')}")

    try:
        data = token_serializer.loads(token)
        user_id = data['user_id']
    except:
        return jsonify({'error': 'Invalid token'}), 401

    try:
        conn = get_db_connection()
        cursor = conn.cursor(MySQLdb.cursors.DictCursor)

        # Get user balance
        cursor.execute("SELECT balance FROM users WHERE id = %s", (user_id,))
        user_data = cursor.fetchone()
        balance = user_data['balance'] if user_data else 0.00

        # Get transactions
        query = """
            SELECT
                t.description,
                t.amount,
                DATE_FORMAT(t.date, '%%d/%%m/%%Y') as formatted_date,
                t.email_sender,
                t.email_receiver,
                CASE
                    WHEN t.id_sender = %s THEN 'outgoing'
                    ELSE 'incoming'
                END AS transaction_direction
            FROM transactions t
            WHERE t.id_sender = %s OR t.id_receiver = %s
            ORDER BY t.date DESC
        """
        cursor.execute(query, (user_id, user_id, user_id))
        transactions = cursor.fetchall() or []

        # Convert Decimal to float
        for t in transactions:
            if isinstance(t['amount'], Decimal):
                t['amount'] = float(t['amount'])

        return jsonify({
            'status': 'success',
            'balance': float(balance),
            'data': transactions
        })

    except Exception as e:
        app.logger.error(f"Dashboard error: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500
    finally:
        if 'conn' in locals():
            conn.close()

# Nuova route: Ottieni user_id dal token (usata dal frontend)
@app.route('/get_user_id')
def get_user_id():
    token = request.args.get('token')
    if not validate_token(token):
        return jsonify({'error': 'Invalid session'}), 401

    try:
        data = token_serializer.loads(token)
        return jsonify({'user_id': data['user_id']})
    except:
        return jsonify({'error': 'Invalid token'}), 401

@app.route('/register', methods=['POST'])
def register():
    required_fields = ['name', 'surname', 'email', 'password']
    if not validate_input(request.form, required_fields):
        return redirect(f"{URL_FRONTEND}/register.html?error={quote('All fields are required')}")

    try:
        name = sanitize_string(request.form['name'])
        surname = sanitize_string(request.form['surname'])
        email = sanitize_string(request.form['email'])
        password = request.form['password']

        if not EMAIL_REGEX.match(email):
            return redirect(f"{URL_FRONTEND}/register.html?error={quote('Invalid email format')}")

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
        if cursor.fetchone():
            return redirect(f"{URL_FRONTEND}/register.html?error={quote('Email already registered')}")

        cursor.execute(
            "INSERT INTO users (name, surname, email, password, balance) VALUES (%s, %s, %s, %s, 1000.00)",
            (name, surname, email, generate_password_hash(password))
        )
        conn.commit()

        return redirect(f"{URL_FRONTEND}/index.html?success={quote('Registration successful. Please login')}")

    except Exception as e:
        app.logger.error(f"Registration error: {str(e)}", exc_info=True)
        return redirect(f"{URL_FRONTEND}/register.html?error={quote('Registration error')}")
    finally:
        if 'conn' in locals():
            conn.close()

@app.route('/transfer', methods=['POST'])
def transfer():
    try:
        token = request.form.get('token')
        if not validate_token(token):
            return jsonify({'status': 'error', 'message': 'Invalid session'}), 401

        try:
            # Decifra il token per ottenere l'user_id
            token_data = token_serializer.loads(token)
            token_user_id = token_data['user_id']
            app.logger.error("Error: 2")
        except:
            return jsonify({'status': 'error', 'message': 'Invalid token'}), 401

        # Verifica corrispondenza con user_id dal form
        form_user_id = request.form.get('user_id')
        if str(token_user_id) != str(form_user_id):
            app.logger.error("Error: 3")
            return jsonify({'status': 'error', 'message': 'User ID mismatch'}), 403

        if not validate_input(request.form, ['user_id', 'recipient_email', 'amount']):
            app.logger.error("Error: 4")
            return jsonify({'status': 'error', 'message': 'All fields are required'}), 400

        try:
            amount = Decimal(request.form['amount'])
            if amount <= 0:
                return jsonify({'status': 'error', 'message': 'Amount must be positive'}), 400
        except:
            return jsonify({'status': 'error', 'message': 'Invalid amount format'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        # Validate sender
        cursor.execute("SELECT id, email, balance FROM users WHERE id = %s FOR UPDATE", (request.form['user_id'],))
        sender = cursor.fetchone()
        if not sender:
            app.logger.error("Error: 5")
            return jsonify({
                'status': 'error',
                'message': 'Invalid user account',
                'redirect': True,
                'redirect_url': f'{URL_FRONTEND}/index.html'
            }), 401

        sender_id, sender_email, sender_balance = sender

        # Validate recipient
        recipient_email = sanitize_string(request.form['recipient_email'])
        if not EMAIL_REGEX.match(recipient_email):
            app.logger.error("Error: 6")
            return jsonify({'status': 'error', 'message': 'Invalid recipient email'}), 400

        cursor.execute("SELECT id, email, balance FROM users WHERE email = %s FOR UPDATE", (recipient_email,))
        receiver = cursor.fetchone()
        if not receiver:
            app.logger.error("Error: 7")
            return jsonify({'status': 'error', 'message': 'Recipient not found'}), 404

        receiver_id, receiver_email, receiver_balance = receiver

        if sender_id == receiver_id:
            app.logger.error("Error: 8")
            return jsonify({'status': 'error', 'message': 'Cannot transfer to yourself'}), 400

        # Check balance
        if sender_balance < amount:
            return jsonify({
                'status': 'error',
                'message': f'Insufficient funds. Your balance: \u20ac{sender_balance:.2f}',
                'max_amount': float(sender_balance)
            }), 400

        # Execute transaction
        new_sender_balance = sender_balance - amount
        new_receiver_balance = receiver_balance + amount
        app.logger.error(sender_id)
        cursor.execute("UPDATE users SET balance = %s WHERE id = %s", (new_sender_balance, sender_id))
        cursor.execute("UPDATE users SET balance = %s WHERE id = %s", (new_receiver_balance, receiver_id))
        cursor.execute(
            """INSERT INTO transactions
            (id_sender, email_sender, id_receiver, email_receiver, amount, description)
            VALUES (%s, %s, %s, %s, %s, %s)""",
            (sender_id, sender_email, receiver_id, receiver_email, amount,
             sanitize_string(request.form.get('description', '')))
        )

        conn.commit()

        return jsonify({
            'status': 'success',
            'message': f'Transfer of \u20ac{amount:.2f} completed successfully',
            'new_balance': float(new_sender_balance)
        })

    except Exception as e:
        app.logger.error(f"Transfer error: {str(e)}", exc_info=True)
        if 'conn' in locals():
            conn.rollback()
        return jsonify({
            'status': 'error',
            'message': 'An error occurred during transfer'
        }), 500

    finally:
        if 'conn' in locals():
            conn.close()

@app.route('/logout')
def logout():
    # Invalida il token reimpostando la secret key (semplice per testing)
    global token_serializer
    token_serializer = URLSafeSerializer(os.urandom(24))  # Nuova chiave casuale

    return redirect(f"{URL_FRONTEND}/index.html?message={quote('Logout successful')}")

@app.before_request
def log_incoming_request():
    app.logger.info(f"Received {request.method} request for {request.url}")
    app.logger.info(f"Headers: {dict(request.headers)}")
    app.logger.info(f"Data: {request.get_data()}")

@app.route('/healthz', methods=['GET'])
def health_check():
    """Endpoint per i probe di Kubernetes"""
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)