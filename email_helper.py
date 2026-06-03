import http.server
import json
import subprocess

class EmailHelperHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/send':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
            
            email = data.get('email', '')
            code = data.get('code', '')
            
            if email and code:
                # Direct URL to the GitHub-hosted LUMA logo (which is fully whitelisted by Google/Gmail image proxy)
                logo_url = "https://raw.githubusercontent.com/kamakshi0421/Luma_App/main/LUMA/images.xcassets/LumaLogo.imageset/LumaLogo.png"
                
                # HTML styling matching the Luma Pink/Rose theme
                html_body = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LUMA Verification Code</title>
</head>
<body style="margin: 0; padding: 0; background-color: #fcf8fa; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #fcf8fa; padding: 40px 0;">
        <tr>
            <td align="center">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px; background-color: #ffffff; border-radius: 24px; box-shadow: 0 8px 30px rgba(219, 115, 158, 0.08); overflow: hidden; border: 1px solid rgba(219, 115, 158, 0.1);">
                    <!-- Header -->
                    <tr>
                        <td align="center" style="padding: 40px 40px 20px 40px;">
                            <img src="{logo_url}" alt="LUMA" width="80" height="80" style="display: block; margin-bottom: 16px; border-radius: 20px;" />
                            <h1 style="margin: 0; font-size: 28px; font-weight: 700; color: #404045; letter-spacing: -0.5px;">LUMA</h1>
                            <p style="margin: 4px 0 0 0; font-size: 14px; color: #737378; font-weight: 500;">Your Journey to Well-being</p>
                        </td>
                    </tr>
                    <!-- Divider -->
                    <tr>
                        <td style="padding: 0 40px;">
                            <div style="height: 1px; background-color: #f0e6eb;"></div>
                        </td>
                    </tr>
                    <!-- Body -->
                    <tr>
                        <td style="padding: 30px 40px 20px 40px; text-align: center;">
                            <h2 style="margin: 0 0 12px 0; font-size: 20px; font-weight: 600; color: #404045;">Verify Your Email</h2>
                            <p style="margin: 0 0 30px 0; font-size: 15px; line-height: 1.6; color: #737378;">
                                Thank you for signing up for LUMA. Use the verification code below to verify your email address and activate your account.
                            </p>
                            <!-- Code Container -->
                            <div style="background-color: #fbf0f4; border-radius: 16px; padding: 20px; display: inline-block; min-width: 200px; border: 1px solid #fadbe6; margin-bottom: 30px;">
                                <span style="font-size: 36px; font-weight: 700; color: #d15c8a; letter-spacing: 6px; font-family: 'Courier New', Courier, monospace; padding-left: 6px;">{code}</span>
                            </div>
                            <p style="margin: 0; font-size: 13px; color: #9c9ca3; line-height: 1.5;">
                                This verification code is valid for 10 minutes.<br>
                                If you didn't request this code, you can safely ignore this email.
                            </p>
                        </td>
                    </tr>
                    <!-- Footer -->
                    <tr>
                        <td align="center" style="padding: 20px 40px 40px 40px; background-color: #faf4f6;">
                            <p style="margin: 0; font-size: 12px; color: #bcaeb4;">&copy; 2026 LUMA App. All rights reserved.</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>"""

                # AppleScript to send mail via local macOS Mail app
                # Escape double quotes and backslashes in HTML for AppleScript
                escaped_html = html_body.replace('\\', '\\\\').replace('"', '\\"')
                
                applescript = f'''
                tell application "Mail"
                    set newMessage to make new outgoing message with properties {{subject:"Verify your LUMA Account", visible:false}}
                    tell newMessage
                        make new to recipient with properties {{address:"{email}"}}
                        set html content to "{escaped_html}"
                        send
                    end tell
                end tell
                '''
                
                try:
                    subprocess.run(["osascript", "-e", applescript], check=True)
                    self.send_response(200)
                    self.send_header('Content-type', 'application/json')
                    self.send_header('Access-Control-Allow-Origin', '*')
                    self.end_headers()
                    self.wfile.write(json.dumps({"status": "sent"}).encode('utf-8'))
                    return
                except Exception as e:
                    print(f"Error sending email: {e}")
                    
            self.send_response(500)
            self.end_headers()

def run(port=8080):
    server_address = ('', port)
    httpd = http.server.HTTPServer(server_address, EmailHelperHandler)
    print(f"Starting local email helper server on port {port}...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    print("Stopping server...")

if __name__ == '__main__':
    run()
