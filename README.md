Gadget PD Pipeline
==================

*A pipeline for differentiating and categorizing patients of Parkinsons and
Essential Tremor using a mixture of genetic and motion tracking techniques.*


Using this pipeline
-------------------

This pipeline is built using [metapipe][mp] and a variety of other tools.
Install the dependencies as follows:

```bash
$ pip install -r requirements.txt
```

Once all the dependencies are installed, the next step is to execute the
pipeline. If you wish to run it locally, then use the following command:

```bash
$ sh run_me.sh <sample_id> <API_USERNAME> <API_PASSWORD>
```

To run this pipeline on an external system, like a cluster, use these commands:

```bash
$ metapipe -j pbs -o pipeline.sh pipeline.mp 
$ qsub pipeline.sh
```


Project Organization
--------------------

This project relies on a few external projects and a variety of shell scripts.
The shell scripts can be found in the `bin/` directory, and the related
packages are in the requirements.txt.

The overall structure of the pipeline can be found in the pipeline.mp file.
This file contains the [metapipe-format][mp] pipeline design.

