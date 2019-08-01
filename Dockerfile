# 명령어 : docker build -t pyapp:latest .
FROM ubuntu:latest

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

# Updating Ubuntu packages
RUN apt-get update 
RUN apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
RUN apt-get install -y wget bzip2

# Add sudo
RUN apt-get -y install sudo

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/
#RUN echo `pwd`

# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.07-Linux-x86_64.sh
RUN bash Anaconda3-2019.07-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.07-Linux-x86_64.sh

# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Configuring access to Jupyter
RUN mkdir /home/ubuntu/notebooks
RUN jupyter notebook --generate-config --allow-root
# RUN echo "c.NotebookApp.password = u'sha1:cb38458414dc:90b048d5ccef9866eb97a28bbc6205443a969a5b'" >> /home/ubuntu/.jupyter/jupyter_notebook_config.py
RUN pip install flask
RUN pip install tensorflow
RUN conda install pandas matplotlib scikit-learn 
RUN pip install keras
RUN conda install jupyter notebook 
# Jupyter listens port: 8888
# flask listen port: 5000
EXPOSE 5000
COPY app.py .


CMD ["python", "app.py"]
#  dock
#   비밀번호 초기화할 값 가져오기
#   docker run -it -p 8888:8888 pyapp:lastet
#   CMD ipython 
#   from notebook.auth import passwd
#   passwd()
#   에서 나온 값을 echo로 넣는다.


#   Run Jupytewr notebook as Docker main process
#   docker run -p 8888:8888 pyapp:latest
#CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip='*'", "--port=8888", "--no-browser"]