<!-- ABOUT THE PROJECT -->
## About The Project

[Computer Architecture Assignment](https://vula.uct.ac.za/access/content/attachment/e48d2390-2c06-46d6-8af5-fd3feae81ce8/Assignments/d99a5897-c6a1-4bb3-951e-f3f6f26f40a5/csc2002s_arch_assign_brief.pdf)

This application was built for the purpose of submission to the University of Cape Town as part of the ciriculum. 
<br>

>**The aim of this project is to learn how to manage data in dynamic ways using assembly through processing ppm images. This is achieved by performing calculations on the pixels from the image files to create a brightened version and a greyscale version respectively** 


### Built With

* Mips Assembly


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites and Installation

A simulator is necessary to run the assembly language programs. QTSpim is reccomended and is what was used to test the programs
* Installing QTSpim
  - Navigate to [Source Forge](https://sourceforge.net/projects/spimsimulator/), click download, and choose the prefered version of QT Spim for your machine

  - Follow installation prompts
* GIMP 
  - Gimp is required to view the ppm images on machines running Windows and Linux. MacOS users need not download GIMP and can view the images in the Preview app. 

<!-- USAGE EXAMPLES -->
## Usage

1. Example images have been provided for running the program with. Should you want to use your own ppm files, place them in the sample_images folder.
2. The application is run from QTSpim
3. These programs were developed on a machine running MacOS, which makes use of the \[LF] character with ASCII value 10 when processing the image files. 

*Please Note:* Users running Windows will need to make the following changes to have the correct output.

In increase_brightness.asm:
  ```
  line 61|     li $t0, *13*
  ```
In greyscale.asm:
  ```
  line 57|     li $t0, *13*
  ```

**Usage examples**: To create picture filters



<!-- ROADMAP -->
## Roadmap

- *Your input image*: Once the program testing image has been chosen, navigate to the first line of each program and put the absolute path to the image as the value for fin.
- *The 2 programs*: increase_brightness.asm and greyscale.asm are the 2 programs that will act on your sample images.
- *Runtime*: After making necessary changes, load the program file for either task and run it in QTSpim.
- *Your output images*: The brightened image will be called output_image.ppm and the black and white image will be called output_greyscale.ppm. 
- *More images*: Should you wish to run either program again and/or with different images, save copies of the new images in another location, clear the contents of the output files and repeat the process. 



<p align="right">(<a href="#About-The-Project">back to top</a>)</p>