import ast
import traceback

FILES = ["MLBrain/test_nn.py", "MLBrain/test2nn.py"]

results = {}

for fp in FILES:
    results[fp] = []
    try:
        src = open(fp, 'r', encoding='utf-8').read()
    except Exception as e:
        results[fp].append(("__file_read__", False, str(e)))
        continue

    tree = ast.parse(src, fp)
    for node in tree.body:
        if isinstance(node, ast.Import):
            for n in node.names:
                stmt = f"import {n.name} as {n.asname}" if n.asname else f"import {n.name}"
                try:
                    exec(stmt, {})
                    results[fp].append((stmt, True, ""))
                except Exception as e:
                    results[fp].append((stmt, False, traceback.format_exc()))
        elif isinstance(node, ast.ImportFrom):
            module = node.module or ""
            names = ", ".join([n.name for n in node.names])
            as_parts = []
            for n in node.names:
                if n.asname:
                    as_parts.append(f"{n.name} as {n.asname}")
                else:
                    as_parts.append(n.name)
            names_str = ", ".join(as_parts)
            stmt = f"from {module} import {names_str}"
            try:
                exec(stmt, {})
                results[fp].append((stmt, True, ""))
            except Exception as e:
                results[fp].append((stmt, False, traceback.format_exc()))

# Print summary
for fp, items in results.items():
    print("FILE:", fp)
    for stmt, ok, info in items:
        status = "OK" if ok else "FAIL"
        print(f"  [{status}] {stmt}")
        if not ok:
            # print only the exception type and first line to keep output compact
            first_line = info.strip().splitlines()[0] if info else ''
            print(f"       -> {first_line}")
    print()
