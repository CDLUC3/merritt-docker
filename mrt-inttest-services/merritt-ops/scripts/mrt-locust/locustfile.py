from locust import HttpUser, task
from bs4 import BeautifulSoup
import os
import urllib.parse

class HelloWorldUser(HttpUser):
    @task
    def state(self):
        self.client.get("/state")
        self.client.get("/state.json")

    @task
    def navigation(self):
        self.client.get("/")
        self.client.get("/home/choose_collection")
        self.client.get("/m/{}".format(os.environ["MNEMONIC"]))
        self.client.get("/s/{}?terms=apple&group={}&commit=Go".format(os.environ["MNEMONIC"], os.environ["MNEMONIC"]))
        for ark in os.environ["TESTARKS"].split(","):
          if ark == '':
            continue
          arkenc = urllib.parse.quote_plus(ark)
          file = "system/mrt-erc.txt"
          fileenc = urllib.parse.quote_plus(file)
          self.client.get("/m/{}".format(arkenc))
          self.client.get("/m/{}/1".format(arkenc))
          self.client.get("/api/presign-file/{}/1/{}".format(arkenc, fileenc))

    def on_start(self):
        #the following does not work with rails CSRF protection
        response = self.client.get("/")
        soup = BeautifulSoup(response.content, features="html.parser")
        auth = soup.findAll("meta", {"name": "csrf-token"})[0].get("content")
        if "MERRITTUSER" in os.environ:
          self.client.post("/login", json={"login": os.environ["MERRITTUSER"], "password": os.environ["MERRITTPASS"], "authenticity_token": auth})
        else:
          self.client.post("/guest_login", json={"authenticity_token": auth})