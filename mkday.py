#!/usr/bin/env python3

import os
import sys
import stat
import re
import shutil
from pathlib import Path as path

# This script is messy and even has some edge cases where it doesn't work.
# It works well enough that I don't care.
# 2022 UPDATE: still bad but less bad

def exit_with_error(message):
	print("Error! %s\nExiting..." % message, file=sys.stderr)
	sys.exit(1)

def get_yes_no(prompt):
	print(prompt)
	while True:
		response = input("(Y/N): ").lower()
		if response == "y" or response == "yes":
			return True
		elif response == "n" or response == "no":
			return False
		else:
			print("Please enter a valid input (Y/N/Yes/No)")

def get_day(prompt):
	print(prompt)
	while True:
		try:
			response = input(">>>")
			if not response == "":
				response = int(response)
				if response > 0:
					return response
				else:
					print("Please enter a valid day number.")
			else:
				return 0
		except KeyboardInterrupt:
			print("\nKeyboard interrupt received. Exiting...")
			sys.exit(0)
		except ValueError:
			print("Please enter a valid integer.")
		except:
			exit_with_error("Failed to read integer input")

def get_puzzle_name(prompt):
	print(prompt)
	while True:
		puzzle_name = input(">>>").lower()
		if puzzle_name:
			puzzle_name = re.sub(r"[\/\\\?\%\*\:\|\"\<\>\.\,\!\@\#\$\^\&\;\-\_\+\=\`\~]", " ", puzzle_name)
			puzzle_name = re.sub(r" +", "-", puzzle_name)
			puzzle_name = puzzle_name.strip()
			break
		else:
			print("Please enter a valid name.")
	return puzzle_name

def get_template(templates):
	choices = ["blank"]
	for t in templates:
		choices.append(t.name)
	choices_str = ""
	for i in range(0, len(choices)):
		choices_str += choices[i]
		if not i == len(choices) - 1:
			choices_str += ", "
	print("Please select a template to use.")
	print("The available choices are: " + choices_str)
	while True:
		template = input(">>>")
		if template in choices:
			break
		else:
			print("Please enter a valid template name.")
	return template

def check_dir_exists(name):
	dir_path = path(name)
	if not dir_path.exists():
		print("\"%s\" directory not found. Making a new one..." % name)
		try:
			dir_path.mkdir()
			return True # directory created
		except:
			exit_with_error("Failed to create directory \"%s\"" % name)
	elif dir_path.is_file():
		exit_with_error("Cannot create \"%s\" directory because it is a file" % name)
	return False # directory found

def make_dir(dir_path):
	path(dir_path).mkdir()

def touch_file(file_path):
	path(file_path).write_text("")

def write_file(file_path, content):
	# this right here sucks
	out_text = "\n".join([line[2:] for line in content.splitlines()]).lstrip("\n")
	path(file_path).write_text(out_text)

def write_file_x(file_path, content):
	write_file(file_path, content)
	make_executable(file_path)

def make_executable(file_path):
	p = path(file_path)
	p.chmod(p.stat().st_mode | stat.S_IEXEC)

def populate_templates():
	write_file("templates/howto.txt",
		"""
		This is the directory containing project templates for various
		languages.
		
		Each template is a directory, and in that directory are all of the
		files and folders for the template that will be copied when making a
		new project.
		
		If a template has a file named "input.txt" then it will be symlinked to
		"input.txt" in the puzzle's root directory, which is created if it
		doesn't exist. This allows all solutions for the same puzzle to share
		the same input file.
		
		Templates for C, Python, and Rust are included.
		Feel free to use them as exmaples and/or modify them!
		
		The only reserved template name is "blank".
		A custom template named "blank" will simply be ignored.
		"""
	)
	print("Created new templates directory, please check templates/howto.txt")
	
	populate_c_template()
	populate_python_template()
	populate_rust_template()
	
	print("Templates initialized, exiting...")
	sys.exit(0)

def populate_c_template():
	make_dir("templates/c")
	touch_file("templates/c/input.txt")
	write_file("templates/c/main.c",
		"""
		#include <stdio.h>
		#include <stdlib.h>
		#include <string.h>
		#include <inttypes.h>
		
		int main() {
			
			FILE* file_p;
			file_p = fopen("input.txt", "r");
			if (file_p == NULL) {
				return EXIT_FAILURE;
			}
			
			fclose(file_p);
			
			return EXIT_SUCCESS;
		}
		"""
	)
	write_file("templates/c/.gitignore",
		"""
		out/
		"""
	)
	write_file_x("templates/c/build.sh",
		"""
		#!/bin/sh
		
		mkdir -p out
		if gcc main.c -o out/main; then
			exec ./out/main
		fi
		"""
	)

def populate_python_template():
	make_dir("templates/python")
	touch_file("templates/python/input.txt")
	write_file_x("templates/python/main.py",
		"""
		#!/usr/bin/env python3
		
		def main():
			
			with open("input.txt") as input_file:
				lines = input_file.read().strip().split("\\n")
			
		
		if __name__ == "__main__":
			main()
		"""
	)

def populate_rust_template():
	make_dir("templates/rust")
	make_dir("templates/rust/src")
	touch_file("templates/rust/src/input.txt")
	write_file("templates/rust/Cargo.toml",
		"""
		[package]
		name = "rust"
		version = "0.1.0"
		authors = [""]
		
		[dependencies]
		"""
	)
	write_file("templates/rust/.gitignore",
		"""
		target/
		Cargo.lock
		"""
	)
	write_file("templates/rust/src/main.rs",
		"""
		fn main() {
			
			let input = include_str!("input.txt").trim();
			let input_lines = input.lines();
			
		}
		"""
	)

def main():
	
	# ensure that all of the directories exist
	check_dir_exists("solutions")
	if check_dir_exists("templates"):
		populate_templates()
	
	# get the paths for the templates and existing solution projects
	templates = [t for t in path("templates").glob("*") if t.is_dir()]
	solutions = [e for e in path("solutions").glob("*") if e.is_dir()]
	
	# get the day numbers for the existing solution projects
	days = {}
	for e in solutions:
		try:
			d = int(e.name[0:2])
			days[d] = e.name
		except:
			exit_with_error("Failed to parse day number for \"%s\"" % e.name)
	
	# determine the highest day number so far
	max_day = 0
	for d in days:
		if d <= 0:
			exit_with_error("Got invalid day number for \"%s\"" % e.name)
		max_day = max(max_day, d)
	day = max_day + 1
	
	print((
		"------------------------------------------------------\n"
		"Welcome to Amy's Advent of Code solution setup helper!\n"
		"------------------------------------------------------"
	))
	
	# get the day of the puzzle
	day_to_use = get_day("Please enter the day for the puzzle. (Default: %d)" % day)
	if not day_to_use == 0:
		day = day_to_use
	
	# get string for the day number
	day_str = ""
	if day < 10:
		day_str = "0" + str(day)
	else:
		day_str = str(day)
	
	# get the solution directory
	puzzle_name = ""
	template = ""
	solution_dir = ""
	existing_puzzle = False
	if day in days:
		print("Existing puzzle found for day %d: %s" % (day, days[day]))
		existing_puzzle = get_yes_no("Do you want to add another solution for this puzzle?")
		if existing_puzzle:
			puzzle_name = days[day]
	while True:
		if not existing_puzzle:
			puzzle_name = get_puzzle_name("Please enter the puzzle name. (e.g. Inverse Captcha)")
		template = get_template(templates)
		if not existing_puzzle:
			solution_dir = "%s-%s/%s/" % (day_str, puzzle_name, template)
		else:
			solution_dir = "%s/%s/" % (puzzle_name, template)
			i = 2
			while True:
				if path("solutions/%s" % solution_dir).exists():
					solution_dir = "%s/%s-%d/" % (puzzle_name, template, i)
					i += 1
				else:
					break
		print("The directory \"%s\" will be created." % solution_dir)
		if get_yes_no("Is this correct?"):
			break
	
	dst = path("solutions/%s" % (solution_dir))
	if not existing_puzzle:
		puzzle_dir = "%s-%s" % (day_str, puzzle_name)
		path("solutions/%s" % puzzle_dir).mkdir()
		path("solutions/%s/input.txt" % puzzle_dir).write_text("")
	if not template == "blank":
		src = path("templates/%s" % template)
		try:
			shutil.copytree(src, dst)
		except:
			exit_with_error("Failed to copy \"%s\" template tree to \"%s\"" % (template, solution_name))
		input_files = [i for i in dst.glob("**/input.txt") if i.is_file()]
		input_path = ""
		if existing_puzzle:
			input_path = "solutions/%s/input.txt" % puzzle_name
		else:
			input_path = "solutions/%s-%s/input.txt" % (day_str, puzzle_name)
		for i in input_files:
			i.unlink()
			try:
				#back_count = len(str(i).split("/")) - len(input_path.split("/"))
				back_count = len(str(i).split("/")) - 3
				symlink_path = ("../" * back_count) + "input.txt"
				i.symlink_to(symlink_path)
			except:
				exit_with_error("Failed to create symlink from \"%s\" to \"%s\"!" % (input_path, i))
		print("Done! Created directory \"%s\" with the \"%s\" template." % (solution_dir, template))
	else:
		try:
			dst.mkdir()
		except:
			exit_with_error("Failed to create directory \"%s\"" % solution_dir)
		print("Done! Created directory \"%s\"" % solution_dir)

if __name__ == "__main__":
	try:
		main()
	except KeyboardInterrupt:
		print("\nKeyboard interrupt received. Exiting...")
		try:
			sys.exit(0)
		except SystemExit:
			os._exit(0)
