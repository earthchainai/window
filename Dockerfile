FROM mcr.microsoft.com/windows/servercore:ltsc2022 # Or similar Windows base image

# Updates and basics 
RUN apt-get update -y 
RUN apt-get install -y wget curl 

# Desktop Environment (Lightweight - XFCE)
RUN wget https://downloads.xfce.org/xfce/4.16/xfce-4.16.tar.bz2 -P /tmp 
RUN tar -xf /tmp/xfce-4.16.tar.bz2 -C /tmp 
# ... (Follow XFCE or your chosen desktop environment installation instructions)

# VNC Server (e.g., TightVNC)
RUN wget https://www.tightvnc.com/download/2.8.63/tightvnc-2.8.63-gpl-setup64.exe -P /tmp
RUN /tmp/tightvnc-2.8.63-gpl-setup64.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART   
RUN net start tightvncserver 

# Install noVNC
RUN wget https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz  -P /tmp \
    && tar -xzf /tmp/v1.3.0.tar.gz -C /opt \
    && ln -s /opt/noVNC-1.3.0/vnc.html /opt/noVNC-1.3.0/index.html 

# Node.js for simple web server
RUN wget https://nodejs.org/dist/v16.19.0/node-v16.19.0-linux-x64.tar.xz -P /tmp \
    && tar -xf /tmp/node-v16.19.0-linux-x64.tar.xz -C /usr \
    && npm install -g http-server 

# Expose ports
EXPOSE 5901  # VNC
EXPOSE 8080  # noVNC Web Access

# Start VNC server & noVNC  
CMD ["/usr/bin/tightvncserver", "-geometry", "1280x720", "-depth", "16", ":", "1", \
     "&", "http-server", "/opt/noVNC-1.3.0", "-p", "8080"] 
