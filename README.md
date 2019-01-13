# PSMSC-DockerSparkHDFS

The objective of this project is to implement an application scenario which illustrates the use of the following techniques:
* [Docker](https://www.docker.com/): it can be used to deploy a cluster of (virtual) machines on your laptop, but can also be used in a distributed setting with several laptops.
* [Spark](https://spark.apache.org/): a spark infrastructure, including hdfs, a master and several slaves must be deployed in the docker infrastructure.
It refers to the courses of Deep Learning of the MSc track *Cloud Computing and Big Data* given at [Toulouse INP-E.N.S.E.E.I.H.T.](http://www.enseeiht.fr/en/index.html) Eng. School and [Paul Sabatier Faculty](http://www.univ-tlse3.fr/home-page-en-379161.kjsp) of Science and Engineering.

## Getting Started
Clone first this git repository, and go into the main folder.

### Prerequisites
You first need to install [Docker](https://www.docker.com/). On Ubuntu:

```
wget -qO- https://get.docker.com/ | sh
```

### Installing
With Docker installed, execute the following script:

```
sudo ./start-ccbd.sh [NCONTAINERS]
```

It will build all the docker images, run all the containers and get you into hadoop master container under root user. You need now to run hadoop:

```
./start-hadoop.sh
```

If you want to run the Word Count example, run the following scripts:

```
cd examples
./start-wordcount.sh
```

## Built With
* [Docker](https://www.docker.com/) - A computer program that performs operating-system-level virtualization
* [Spark](https://spark.apache.org/) - A unified analytics engine for large-scale data processing.
* [Hadoop](https://hadoop.apache.org/) - An open-source software for reliable, scalable, distributed computing.


## Authors
* **Guillaume Hugonnard** - *MSc-PSMSC, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering* - GuillaumeHugonnard
* **Tom Ragonneau** - *MSc-PSMSC, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering* - [TomRagonneau](https://github.com/TomRagonneau)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [Daniel Hagimont](http://sd-127206.dedibox.fr/hagimont/) - *MSc-PSMSC speaker, INPT-ENSEEIHT Eng. School and Paul Sabatier Faculty of Science and Engineering*
