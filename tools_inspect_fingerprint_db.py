import sqlite3

try:
    conn = sqlite3.connect('MLBrain/fingerprint.db')
    c = conn.cursor()
    tables = [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='table';")]
    print('TABLES:', tables)
    if 'fingerprints' in tables:
        rows = c.execute("SELECT id, substr(data,1,200) FROM fingerprints LIMIT 3").fetchall()
        for r in rows:
            print('ROW:', r)
    else:
        print('No fingerprints table found')
except Exception as e:
    print('ERROR:', e)
