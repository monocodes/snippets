# Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT / BT

<https://www.programmersought.com/article/28182204085/>

tags: [Synology](https://www.programmersought.com/tag/Synology/) [nas](https://www.programmersought.com/tag/nas/) [qbittorrent](https://www.programmersought.com/tag/qbittorrent/) [PT](https://www.programmersought.com/tag/PT/) [download](https://www.programmersought.com/tag/download/)

The use of low-power platform Synology hang upload / download should be appropriate enough

Ado, we quickly begin

I use a black dress version of the system is DSM6.1

## 1, the installation Docker(Already installed you can skip the second step)

Click Package Center → All → Click the left scroll to the middle position will be able to find the "Docker" (cute whale cruises ICO)

Docker course, you can search directly in the search box, it is possible

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/a5ce8974c8e2cf691b6c39032f797855.jpeg)

Wait a moment later, click the top left corner exhale "All Programs" icon will appear a Docker

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/c7322983d5334b04ffc63123056df8c9.jpeg)

## 2, download qbittorrent images, and configured to run (Emphasis! Knocking blackboard!)

→ Click the registry right of the search bar Direct Search "qbittorrent"

Select the bottom of the second "linuxserver / qbittorrent"Double-click the installation!

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/c1a938fc8b6df076f7b63c90917d50f7.jpeg)

Version, then directly select latest (most recent) enough

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/d66d362d2a23ff378a8f131d5581b003.jpeg)

Waiting for the download to complete before the image, we create two folders are used to store qbittorrent download and configuration files

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/e7cb739a8a8d267175caf436fbf8491a.jpeg)

Create a folder named "qbittorrent" Create two subfolders "config" "downloads" below it

According to this folder is named the best format, one is for the convenience to facilitate future maintenance, and secondly, in order to facilitate the configuration file write back

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/7920d779601d911ecde17f702209accc.jpeg)

Then we give permission to these folders everyone, otherwise the seeds may have been added but did not speed

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/eac8d9d4e356dcec0e8bd47f3f66c88e.jpeg)

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/e497626f606f433a4a545e5149cbb8c6.jpeg)

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/57d54f4470c5526a2330c69b822af92f.jpeg)

This time the image has been downloaded almost finished

In the "image" list select the downloaded image just click on the "Start"

Container name can easily play on the right side, basically do not see in normal use, so the default is like

Click the "Advanced Settings"

Add two directories just created in the "Volumes" and fill in the load path "/ config" and "/ downloads" respectively

Under explain a little here, a path on the left is your nas the true path, the right path is the path to the container in the software runs, it sees, is relational mapping

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/327028ef4b82f2c264694c4df088a5f9.jpeg)

And then to the port settings

Modify the default port 8080 to 8999, the protocol type is tcp (you can easily change this port, also followed behind the configuration change on the line, as I do not know if it's on the line)

Notice that you change the default port of 8080, as other software Synology port conflict

In the bottom of theLocal portChanged to values corresponding to the right

Port here do not tangle, found later to be changed at any time be modified

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/df72ca7f9f8d0687ef00fe98a215b279.jpeg)

The last configuration environment variable

Three are below fill in their go

WEBUI_PORT 8999 web access port number

SavePath / downloads download save path

Save path TempPath / downloads temporary files

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/28b67b74652702f1bc531cc5fa48e31f.jpeg)

Then you can determine the exit advanced settings, click Next to confirm settings

After confirmation, you can "apply", automatic operation

Wait a moment, in the "container" can be found in the container we just created a ~

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/61eb051d97b32543e1f380e791babd11.jpeg)

Then open your browser and enter the URL of our nas plus we set the port number xxx.xxx.xxx.xxx:8999

The default user name: admin, default password: adminadmin

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/a999fbdede613ff18352db5edf6365c9.jpeg)

After landing, the default interface is in English, given that we are so patriotic, it is necessary to replace the Chinese friends ~

Click below to save

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/c82eaf3c569d3c8fc7c85971f205a6a0.jpeg)

Then quickly add a connection, take the hottest little sister try to speed

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/faca9fdb440b491ecc22886a616f41be.jpeg)

## 3. Other settings

The basic used qb of TPer certainly no stranger to setting items Needless to say, say it in several places here

1, first of all we TPer, then, is to turn off DHT, and this place is closed

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/73bdf6cf01e69678f295edd6cb7bb9ca.jpeg)

2, this path is to map the path we add, not real nas path

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/d06b66aef6c73084642fa8ff70dc4521.png)

3, if you want to modify the port, above all the places related to the 8999 port are set to the port you want to ~ ~

Well, if all else fails, you can leave a message to me, or my private letter mail [[email protected\]](https://www.programmersought.com/cdn-cgi/l/email-protection)

Incidentally, seeking a bread medicine, if passed by chiefs who reward, brother grateful to ensure seen as treasures, will not live up to the attention of big brother ~

Email：[[email protected\]](https://www.programmersought.com/cdn-cgi/l/email-protection)

If you think my article is written also, throw a coin invited me to drink, I am also very happy ah ~ ~ ~

![img](./Use Synology nas Docker platform installation qb (qbittorrent) to achieve PT - BT.assets/f7472bd59ee1f897002bce4dd840837e.jpeg)
