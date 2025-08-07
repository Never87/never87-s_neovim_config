import http.server
import json
import os
import re
from pathlib import Path

# CPH 使用的是这个端口
PORT = 27121

# 你希望保存的路径（保持你提供的目录）
BASE_DIR = Path("D:/Wok/C++Projects/algorithm_vim").resolve()

# 模板文件路径
TEMPLATE_PATH = Path.home() / ".config" / "nvim" / "cphelper" / "template.cpp"

def sanitize(name: str) -> str:
    name = re.sub(r"[\\/:*?\"<>|]", "_", name)
    return name.replace(" ", "_")

class CPHHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers["Content-Length"])
        body = self.rfile.read(content_length)
        data = json.loads(body)

        problem_name = sanitize(data.get("name", "Unnamed_Problem"))
        dir_path = BASE_DIR / problem_name
        (dir_path / "tests").mkdir(parents=True, exist_ok=True)

        for idx, case in enumerate(data.get("tests", []), 1):
            (dir_path / "tests" / f"in{idx}").write_text(case["input"], encoding="utf-8")
            (dir_path / "tests" / f"out{idx}").write_text(case["output"], encoding="utf-8")

        main_cpp = dir_path / "main.cpp"
        if not main_cpp.exists() and TEMPLATE_PATH.exists():
            content = TEMPLATE_PATH.read_text(encoding="utf-8")
            main_cpp.write_text(content, encoding="utf-8")

        print(f"[✅] 已导入：{problem_name} → {dir_path}")

        self.send_response(200)
        self.end_headers()

def main():
    print(f"🌐 正在监听 Competitive Companion (http://localhost:{PORT})")
    print(f"📁 文件将保存至: {BASE_DIR}")
    server = http.server.HTTPServer(('', PORT), CPHHandler)
    server.serve_forever()

if __name__ == '__main__':
    main()

