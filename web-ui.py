#!/usr/bin/env python3

# This code is not ready for production use. It is a proof of concept only.
# The displayed menu is entire hard coded and not dynamic. If you know how to make
# it dynamic, please let me know.

import os
import http.server
import socketserver

class MenuHandler(http.server.BaseHTTPRequestHandler):
  def do_GET(self):
    self.send_response(200)
    self.send_header('Content-type','text/html')
    self.end_headers()

    # Display menu
    self.wfile.write(b'<html><body>')
    self.wfile.write(b'<h1>Kiosk Menu - Controls</h1>')
    self.wfile.write(b'<ul>')
    self.wfile.write(b'<li><a href="/k_pwr_on">Power on the screen</a></li>')
    self.wfile.write(b'<li><a href="/k_pwr_off">Power off the screen</a></li>')
    self.wfile.write(b'<li><a href="/k_refresh">Force screen refresh</a></li>')
    #self.wfile.write(b'<li><a href="/k_refresh_set">Set refresh time</a></li>')
    self.wfile.write(b'</ul>')
    self.wfile.write(b'<h1>Kiosk Menu - Which would you like to display?</h1>')
    self.wfile.write(b'<ul>')
    self.wfile.write(b'<li><a href="/k_dash">Home Dashboard</a></li>')
    self.wfile.write(b'<li><a href="/k_fa">Flight tracking</a></li>')
    self.wfile.write(b'<li><a href="/k_cal">My Calendar</a></li>')
    self.wfile.write(b'<li><a href="/k_op">Octoprint</a></li>')
    self.wfile.write(b'<li><a href="/k_opdash">Octoprint Dashboard</a></li>')
    self.wfile.write(b'<li><a href="/k_weather">Local Weather</a></li>')
    self.wfile.write(b'<li><a href="/k_github">GitHub Status Dashboard</a></li>')
    self.wfile.write(b'<li><a href="/k_zendesk">Zendesk Status Dashboard</a></li>')
    self.wfile.write(b'<li><a href="/k_slack">Slack Status Dashboard</a></li>')
    self.wfile.write(b'</ul>')
    self.wfile.write(b'</body></html>')

    # Handle menu item selection
    ##############################################################################
    # Controls
    ##############################################################################
    if self.path == '/k_pwr_on':
      os.system('kioskctl on')
      self.wfile.write(b'<p>Turned on the display</p>')
    if self.path == '/k_pwr_off':
      os.system('kioskctl off')
      self.wfile.write(b'<p>Turned off the display</p>')
    if self.path == '/k_refresh':
      os.system('kioskctl refresh')
      self.wfile.write(b'<p>Refreshing the screen</p>')

    ##############################################################################
    # Broken code somewhere here. WebUI fails to return but does execute command
    ##############################################################################
    # Refresh set time
    if self.path == '/k_refresh_set':
      # Ask user for number
      self.wfile.write(b'<form action="/k_refresh_set" method="POST">')
      self.wfile.write(b'<label>How many seconds between refreshes?:</label><br>')
      self.wfile.write(b'<input type="text" name="number"><br>')
      self.wfile.write(b'<input type="submit" value="Submit">')
      self.wfile.write(b'</form>')

    def do_POST(self):
      # Get number from user
      content_length = int(self.headers['Content-Length'])
      body = self.rfile.read(content_length)
      number = int(body.decode().split('=')[1])
  
      # Run command with number as argument
      command = 'kioskctl refresh {}'.format(number)
      os.system(command)
      #elf.wfile.write(b'<p>Ran command with number {}</p>'.format(str(number).encode()))
  
      # Display return to main menu button
      self.wfile.write(b'<form action="/" method="GET">')
      self.wfile.write(b'<input type="submit" value="Return to main menu">')
      self.wfile.write(b'</form>')


    ##############################################################################
    # Display destinations
    ##############################################################################
    # Launch home  dashboard
    if self.path == '/k_dash':
      os.system('kioskctl dash')
      self.wfile.write(b'<p>Displaying home dashboard</p>')
    # Launch Local flight tracking
    if self.path == '/k_fa':
      os.system('kioskctl fa')
      self.wfile.write(b'<p>Displaying local flight tracking</p>')
    # Launch My Calendar
    if self.path == '/k_cal':
      os.system('kioskctl cal')
      self.wfile.write(b'<p>Displaying my calendar</p>')
    # Launch Octoprint
    if self.path == '/k_op':
      os.system('kioskctl op')
      self.wfile.write(b'<p>Displaying Octoprint</p>')
    # Launch Octoprint Dashboard
    if self.path == '/k_opdash':
      os.system('kioskctl opdash')
      self.wfile.write(b'<p>Displaying Octoprint Dashboard</p>')
    # Launch Local Weather
    if self.path == '/k_weather':
      os.system('kioskctl weather')
      self.wfile.write(b'<p>Displaying local weather</p>')
    # Launch GitHub Status Dashboard
    if self.path == '/k_github':
      os.system('kioskctl github')
      self.wfile.write(b'<p>Displaying GitHub Status Dashboard</p>')
    # Launch Zendesk Status Dashboard
    if self.path == '/k_zendesk':
      os.system('kioskctl zendesk')
      self.wfile.write(b'<p>Displaying Zendesk Status Dashboard</p>')
    # Launch Slack Status Dashboard
    if self.path == '/k_slack':
      os.system('kioskctl slack')
      self.wfile.write(b'<p>Displaying Slack Status Dashboard</p>')


#    # Launch dashboard
#    if self.path == '/k_X':
#      os.system('k X')
#      self.wfile.write(b'<p>Displaying X</p>')

def main():
  # Create web server and specify handler to handle requests
  with socketserver.TCPServer(("", 12000), MenuHandler) as httpd:
    print("Serving menu on port 12000...")
    httpd.serve_forever()

main()

