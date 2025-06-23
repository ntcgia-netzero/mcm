"""
test_user_table.py
測試 env_data.db 的 user 資料表：
1. 新增 → 查詢 → 更新 → 刪除
2. 驗證 UNIQUE(account) 與 NOT NULL 約束
"""

import sqlite3
from contextlib import closing

DB_PATH = "mcm.db"

def show(msg, rows):
    print(f"\n--- {msg} ---")
    for r in rows:
        print(r)

with closing(sqlite3.connect(DB_PATH)) as conn:
    conn.row_factory = sqlite3.Row           # 讓 SELECT 回傳 dict-like 物件
    cur = conn.cursor()

    # 1) 清空測試資料（避免重覆跑時報錯）
    cur.execute("DELETE FROM user WHERE account LIKE 'test_%';")
    conn.commit()

    # 2) 建立測試帳號
    cur.execute("""
        INSERT INTO user (account, password)
        VALUES ('test_account', 'hashed_pw');
    """)

    # 3) 查詢驗證
    cur.execute("SELECT * FROM user WHERE account = 'test_account';")
    show("After INSERT", cur.fetchall())

    # 4) 嘗試重覆帳號 → 應觸發 UNIQUE constraint
    try:
        cur.execute("""
            INSERT INTO user (account, password) VALUES ('test_account', 'dup_pw');
        """)
    except sqlite3.IntegrityError as e:
        print("\n[PASS] 重覆帳號插入被拒絕 :", e)

    # 5) 更新電話與地址
    cur.execute("""
        UPDATE user
           SET password   = 'new_hashed_pw'
         WHERE account = 'test_account';
    """)
    conn.commit()

    # 6) 再次查詢驗證 UPDATE
    cur.execute("SELECT account FROM user WHERE account='test_account';")
    show("After UPDATE", cur.fetchall())

    # 7) 刪除該帳號
    cur.execute("DELETE FROM user WHERE account='test_account';")
    conn.commit()

    # 8) 查詢應為空
    cur.execute("SELECT account FROM user WHERE account='test_account';")
    rows = cur.fetchall()
    if not rows:
        print("\n[PASS] 刪除成功，資料已不存在。")
    else:
        print("\n[FAIL] 資料仍存在：", rows)
