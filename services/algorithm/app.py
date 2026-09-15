from http.server import BaseHTTPRequestHandler, HTTPServer
import time

STARTED = time.time()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/healthz":
            body, content_type = b'{"status":"ok"}\n', "application/json"
        elif self.path == "/metrics":
            uptime = time.time() - STARTED
            body = f"algorithm_up 1\nalgorithm_uptime_seconds {uptime:.0f}\n".encode()
            content_type = "text/plain; version=0.0.4"
        else:
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)


HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()

