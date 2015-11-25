################ CHANGELOG #####################
#
# v0.0 - 8/26/15 15:55 - Intial Version. Library designed to provide image processing capabilites
# v0.1 - 8/27/15 14:46 - Added basic version of screenshot grabbing. Need to make it so screenshot is saved
# v0.2 - 8/27/15 14:56 - Added pathing to save the screenshot to a specific place
# v0.3 - 8/28/15 17:28 - Added crop_image and template matching
# v0.4 - 9/2/15 13:55 - Fixed up template matching to return a usable result
# v0.5 - 11/18/15 00:26 - Added function to resize the image
#
################ END CHANGELOG ################

################ TODO #####################
#
#
#
################ END TODO ################

import os, imp
import cv2

import PIL
from PIL import ImageGrab
from PIL import Image

#get Digital_Library base_path
base_path = str(os.path.abspath(__file__))
temp_path = base_path.split("\\")
file_name = temp_path[len(temp_path)-1]
base_path = temp_path[0]
for ii in range(1, len(temp_path)):
	if temp_path[ii] == file_name:
		break
	if len(base_path) > 0 and base_path[len(base_path)-1] == ':':
		base_path += "\\"
		base_path += temp_path[ii]
	else:
		base_path = os.path.join(base_path, temp_path[ii])

#setup paths
lib_path = base_path

#load libraries
execute_lib = imp.load_source('execute_lib', os.path.join(lib_path, 'execute_lib.py'))

#PRIVATE FUNCTIONS

#PUBLIC FUNCTIONS

#creates a new image cropped given the dimensions
def crop_image(image_path, dest_path, start_point, crop_box_size):
	img = Image.open(image_path)
	w,h = img.size

	start_x = start_point[0]
	start_y = start_point[1]

	end_x = crop_box_size[0]
	end_y = crop_box_size[1]
	end_x += start_x
	if end_x > w:
		end_x = w
	end_y += start_y
	if end_y > h:
		end_y = h
	img2 = img.crop((start_x, start_y, end_x, end_y))
	img2.save(dest_path)

#changes the image size
def resize_image(image_path, destination_image, new_x_size, new_y_size):
	img = Image.open(image_path)
	img = img.resize((new_x_size, new_y_size), PIL.Image.ANTIALIAS)
	img.save(destination_image)


#TEST CODE
#get_screenshot_of_active_window('carbonpoker')
#crop_image("E:\\Digital_Library\\temp\\poker_script\\screenshots\\current_image.jpg", "E:\\Digital_Library\\temp\\poker_script\\screenshots\\current_image_cropped.jpg", (30,30), (100,100))
#perform_template_matching("E:\\Digital_Library\\temp\\poker_script\\screenshots\\current_image_cropped.jpg", "E:\\Digital_Library\\temp\\poker_script\\screenshots\\current_image.jpg")


