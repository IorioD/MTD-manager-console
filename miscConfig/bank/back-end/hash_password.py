from werkzeug.security import generate_password_hash

# Inserisci la password da hashare
passwords = ["Giovanni", "Maria", "Luca", "Anna", "Marco"]

# Apri il file in modalità scrittura
with open("hashed_passwords.txt", "w") as file:
    for i, password in enumerate(passwords, start=1):
        hashed_password = generate_password_hash(password)
        output = f"Password hashata{i}: {hashed_password}\n"
        print(output, end="")  # Stampa a schermo
        file.write(output)  # Scrive nel file

print("Le password hashate sono state salvate in 'hashed_passwords.txt'")
