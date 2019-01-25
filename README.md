# PSMSC-DockerSparkHDFS

The objective of this project is to implement an application scenario which illustrates the use of the following techniques:
* [Docker](https://www.docker.com/): it can be used to deploy a cluster of (virtual) machines on your laptop, but can also be used in a distributed setting with several laptops.
* [Spark](https://spark.apache.org/): a spark infrastructure, including hdfs, a master and several slaves must be deployed in the docker infrastructure.

It refers to the track *Performance in Software, Media, and Scientific Computing* of the MSc course *Cloud Computing and Big Data* given at [Toulouse INP-E.N.S.E.E.I.H.T.](http://www.enseeiht.fr/en/index.html) Eng. School and [Paul Sabatier Faculty](http://www.univ-tlse3.fr/home-page-en-379161.kjsp) of Science and Engineering.

## Getting Started
Clone first this git repository, and go into the main folder.

### Prerequisites
You first need to install [Docker](https://www.docker.com/). On Ubuntu:

```
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
```

### Installing

#### Locally
With Docker installed, execute the following script:

```
./start-ccbd.sh <n>
```

with *n* being the total number of container which will be built (1 master + (*n-1*) slaves)

It will build all the docker images, run all the containers and get you into hadoop master container under root user and execute hadoop.

Now all you need to do in order to run the Word Count example is to execute the following lines: 

```
cd examples
./start-wordcount.sh
```
The time it took, for your configuration, to count the words in file-wordcount.txt is displayed at the end of the execution.

#### Remotely
Install Docker on every guest host which will be used.

With Docker installed on every guest host which will be used, set each IP address as static (be sure to keep internet access).

Every worker host communicates its RSA key to the manager who saves them in his authorized_keys.

Modify the set-configuration.sh on the manager as follows :
  * Put the manager's IP address
  
Modify the set-configuration.sh on the workers as follows :
  * Put the manager's host name
  * Put the IP address of the manager
  * Put the IP address of the worker

On every guest host, execute the following script :

```
sudo ./set-ports.sh
```

On the manager guest host execute the following script :

```
./start-ccbd.sh <n> <m>
```
with *n* being ... and *m* being ...
It will build all the docker images, run all the containers and get you into hadoop master container under root user.

When the previous script is finished, each worker executes the following script : 

```
./start-ccbd.sh <i> <n>
```
with *i* being ... and *n* being ...
You now do not have to do anything on the worker guest hosts. Just make sure to keep them powered on.

On the manager host, execute the following script:
```
start-hadoop.sh
cd example/
./start-wordcount.sh
```

The time it took spark to count the words in file-wordcount.txt is displayed and saved */tmp/time-wordcount.log*.

## Built With
* [Docker](https://www.docker.com/) - A computer program that performs operating-system-level virtualization
* [Spark](https://spark.apache.org/) - A unified analytics engine for large-scale data processing.
* [Hadoop](https://hadoop.apache.org/) - An open-source software for reliable, scalable, distributed computing.


## Authors
* **Guillaume Hugonnard** - *MSc-PSMSC, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering* - [GuillaumeHugonnard](https://github.com/GuillaumeHugonnard)
* **Tom Ragonneau** - *MSc-PSMSC, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering* - [TomRagonneau](https://github.com/TomRagonneau)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [Daniel Hagimont](http://sd-127206.dedibox.fr/hagimont/) - *MSc-PSMSC speaker, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering*
