import sqlite3
import hashlib
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DB = "users.db"

def get_db():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db()
    conn.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    """)
    conn.commit()
    conn.close()

init_db()

def hash_pwd(pwd: str) -> str:
    return hashlib.sha256(pwd.encode('utf-8')).hexdigest()

class RegisterModel(BaseModel):
    email: EmailStr
    password: str

class LoginModel(BaseModel):
    email: EmailStr
    password: str

@app.get("/")
def get_root():
    return {"msg": "Welcome to the FastAPI User Management System"}

@app.post("/register")
def register(data: RegisterModel):
    hashed = hash_pwd(data.password)
    conn = get_db()
    try:
        conn.execute("INSERT INTO users (email, password) VALUES (?, ?)", (data.email.lower(), hashed))
        conn.commit()
    except sqlite3.IntegrityError:
        raise HTTPException(400, detail="Email already registered")
    finally:
        conn.close()
    return {"msg": "註冊成功"}

@app.post("/login")
def login(data: LoginModel):
    hashed = hash_pwd(data.password)
    conn = get_db()
    cur = conn.execute("SELECT password FROM users WHERE email = ?", (data.email.lower(),))
    row = cur.fetchone()
    conn.close()
    if not row or row["password"] != hashed:
        raise HTTPException(401, detail="帳號或密碼錯誤")
    return {"msg": "登入成功", "token": "fake-jwt-token"}
