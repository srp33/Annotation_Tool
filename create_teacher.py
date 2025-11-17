#!/usr/bin/env python3
"""
Script to create the initial teacher user.
Run this once to set up the first teacher account.
"""
import sys
from pathlib import Path
from sqlalchemy import create_engine, text
import hashlib
import datetime as dt

BASE_DIR = Path(__file__).parent.resolve()
DATABASE_URL = f"sqlite:///{BASE_DIR / 'app.db'}"

def hash_password(password: str) -> str:
    """Simple password hashing"""
    return hashlib.sha256(password.encode()).hexdigest()

def main():
    engine = create_engine(DATABASE_URL, future=True)
    
    print("Create Teacher Account")
    print("=" * 40)
    
    username = input("Username: ").strip()
    if not username:
        print("Error: Username is required")
        sys.exit(1)
    
    password = input("Password: ")
    if not password:
        print("Error: Password is required")
        sys.exit(1)
    
    password_hash = hash_password(password)
    
    try:
        with engine.begin() as conn:
            conn.execute(
                text("""
                    INSERT INTO users (username, password_hash, role, created_at)
                    VALUES (:username, :password_hash, :role, :created_at)
                """),
                {
                    "username": username,
                    "password_hash": password_hash,
                    "role": "teacher",
                    "created_at": dt.datetime.utcnow().isoformat()
                }
            )
        print(f"\n✓ Teacher account '{username}' created successfully!")
        print("You can now log in at the application.")
    except Exception as e:
        print(f"\n✗ Error: {e}")
        print("The username might already exist.")
        sys.exit(1)

if __name__ == "__main__":
    main()

