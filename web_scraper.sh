#!/bin/bash

PATH=/bin:/usr/bin:

#NONE='\033[00m'
#RED='\033[01;31m'
#GREEN='\033[01;32m'
#YELLOW='\033[01;33m'
#PURPLE='\033[01;35m'
#CYAN='\033[01;36m'
#WHITE='\033[01;37m'
#BOLD='\033[1m'
#UNDERLINE='\033[4m'


echo "*********************************************************************************"
echo "					Web Scraper!"
echo "*********************************************************************************"
echo "	A script to make your searches faster and easier"
echo "Search for movie ratings, book ratings or check out the best prices on snapdeal!"
echo ""
echo ""

echo "Press enter to continue"
read a

#zenity --info --text '<span foreground="blue" font="32">Some\nbig text</span>\n\n<i>(it is also blue)</i>'

zenity --width=500 --height=500 --info --window-icon=web --text '<span foreground="black" font="26">Welcome!\nYou are about to enter the world of Web Scraping.\n 
Get ready to experience the power of BASH. \nPress OK to proceed</span>' 2>/dev/null

if [ "$?" = 0 ]
	then
	x=$(zenity --width=500 --height=500 --entry-text="Enter 1 or 2" --entry --title="Enter an option!" --text=" 
	Want to watch a new movie but don't know how good it is?
	Or want to check out the price of a new product on Snapdeal? Here's your chance!!
	

	Enter 1 for Ratings and Reviews from IMDB.
	Enter 2 for Snapdeal." 2>/dev/null)

	if [ "$x" = 1 ]
		then

		string=$(zenity --width=500 --height=500 --entry --title="Ratings!" --text="\n\n\nEnter the name of the movie" 2>/dev/null) 
		#echo $y
		#Web Scraping Code comes here
		lynx -source "http://www.imdb.com/find?ref_=nv_sr_fn&q=$string&s=all"| grep -o -E "/title/.{0,9}"| sed 's/\/title\///g' > file5
		sed '1d' file5 > file6

		read var < file6
		echo $var

		echo -e "Rating : \n" > file7
		tput sgr0
		lynx -dump "http://www.imdb.com/title/$var/?ref_=fn_al_tt_1" | grep  -E -m1 "{0,3}./10" >> file7  

		echo -e "\n Director : " >> file7
lynx -source "http://www.imdb.com/title/$var" | grep -m2 "itemprop=\"name\""| sed '1d' | sed 's/<[^>]\+>//g'| grep -o ">.*" | sed 's/>//g' >> file7

		echo -e "\n Cast :" >> file7
       lynx -source "http://www.imdb.com/title/$var" | grep -a -Pzo '.*castlist_label(.*\n)*' | sed '/fullcredit/,$d' |grep  "itemprop=\"name\""|sed 's/<[^>]\+>//g' | sed 's/^................//' >> file7

		echo -e "\n\n" >> file7
		echo -e "Audience Review:\n" >> file7
		lynx -source "http://www.imdb.com/title/$var" | grep   "reviewBody.*" |sed 's/<[^>]\+>//g'| sed 's/&#x27//g' | sed 's/&#x22//g'|sed 's/&#x96//g'| sed 's/\;//g' >> file7

		



		echo -e "\n\nStoryline :\n " >> file7

		lynx -source "http://www.imdb.com/title/$var/?ref_=fn_ft_tt_1" | grep -C2 "itemprop=\"description"  |sed 's/<[^>]\+>//g'|sed 's/Written by//g'| grep -Pzo '.*Storyline(.*\n)*' | sed '2d'| sed '3d'|sed '4d'|sed '1d'|sed '5d'|sed 's/&#x27//g' >> file7
		zenity --text-info --width=700 --height=700 --title="Movie Rating and Review" --filename=file7 2>/dev/null

		#Trailer
		zenity --question --width=300 --height=300 --text="Do you want to watch the trailer of this movie?" 2>/dev/null
		
		if [ "$?" = 0 ]
			then
				srh_str=$string" trailer"
				echo $srh_str > URL.txt
				srh_str=$(tr ' ' '+' < URL.txt)
				echo $srh_str

				url=$(lynx -source https://www.youtube.com/results?search_query=$srh_str | grep -E -o -m1 'watch\?.{0,13}')
				echo $url
				#url="watch?v=6L6XqWoS8tw"
				url="http://www.youtube.com/$url"
				echo $url

				#sensible-browser youtube.com/$url
				sensible-browser $url
		fi


	fi 

	if [ "$x" = 2 ]
		then
		string=$(zenity --width=500 --height=500 --entry --title="Snapdeal!" --text="\n\n\nEnter the product name"  2>/dev/null) 
		#echo $z
		lynx -source "https://www.snapdeal.com/search?keyword=$string&catId=0&categoryId=0&suggested=false&vertical=p&noOfResults=20&searchState=&clickSrc=go_header&lastKeyword=&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&categoryUrl=&url=&utmContent=&dealDetail=&sort=rlvncy"|grep -E  -o  "product-title \" title=\".{0,600}" | sed 's/product-title \" title=\"//g' | sed 's/\".*//g' > file1

		lynx -source "https://www.snapdeal.com/search?keyword=$string&catId=0&categoryId=0&suggested=false&vertical=p&noOfResults=20&searchState=&clickSrc=go_header&lastKeyword=&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&categoryUrl=&url=&utmContent=&dealDetail=&sort=rlvncy"|grep -E -o  "data-price.{0,8}"| grep -o "[0-9]*" > file2

		diff -y  file1 file2 > file3
		#cat file3

		zenity --text-info --width=700 --height=700 --title="Available Product List" --filename=file3 2>/dev/null
		#zenity --info --width=700 --height=700 --text="`cat file3`"
	fi
fi                          

