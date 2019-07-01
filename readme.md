# Next Gen Image Creation

<blockquote>This is a simple block of code (all shell code really) that does a few image and S3 things. I am not sure if it will work on non-mac operating systems. It should though, with slight adjustments from what I have written.</blockquote>

## What you need

1. `brew install imagemagick` or the like

   - [Link to imagemagick page](https://www.imagemagick.org)
   - It's basically the most popular image CLI library, it's [written mostly in C](https://github.com/ImageMagick/ImageMagick)

2. This is optional. Hook up an AWS account to your CLI.
   - [How to sign up](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
   - [Install the CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
   - [Configure the CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration)

### How to start

1. Clone this repository, store it wherever is fitting. You can do several things here:

   - Create images in next gen formats (as V8 (Google) and Webkit(Apple) are optimised to handle specific image types)
     - webp for Google
     - JPEG 2000 (jp2) for Apple
   - Create placeholders for your images (for lazy loading)
   - Push this content to an AWS S3 bucket

2. After cloning, you have several files to work with. They are all shell scripts. Think of them as utility files. Below is a quick rundown for each one.

<br />

### Something to know (common pitfalls)

1. Only run the script from the root directory.
2. Other stuff to think of in the future...

#### CreateS3Bucket.sh

Creates an s3 bucket with public read access. Public read access means that anyone can access the image from the s3 url. But, people cannot publicly `Post`, `Put`, or `Delete`. Only `Get`.

<blockquote>Do not put sensitive data, AWS predominantly recommends that people do not grant public read access as sensitive data such as voter and military information has been publicly accessible. This should not matter here, as this is solely for images.</blockquote>

<b>What to do before calling it</b>

- Set up AWS account and add credentials to your terminal if you have not. Other than that, think of a good bucket name.

<b>How to call it</b>

- `sudo bash ./createS3Bucket.sh`

<b>Options</b>

- `bucket="somebucketname"`
  - Required
  - [Requirements for naming an s3 bucket](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-s3-bucket-naming-requirements.html)
- `region=us-west-1`
  - Not required
  - Default: `us-east-1`

<b>What you'll see in the console:</b>

1. `{"Location": "/somebucketname"}`
   - Which isn't important, it comes automatically from the AWS CLI.
2. Then this: `upload: ./duck.png to s3://somebucketname/duck.png`
   - Which again is something from the AWS CLI.
3. A string that says this: `Check if it works by clicking this url: https://somebucketname.s3.amazonaws.com/duck.png`. Which, when clicked, should show a little duck image, as that is the test image. You should take a peek in your AWS console as well.

<b>What to know</b>

- You have this bucket in your AWS account now. It's not optimised to security or the like but it works and is accessible. Best of all, you can now push images to it.

<br />

#### `ConvertFiles.sh`

Converts a group of images to nextGen formats.

<b>What to do before calling it</b>

- Add all the images you want to be converted to the Images folder. That's your main folder for Images. After conversion, all the images will be there. The ones you put there, and the new ones as well. That's all that needs to be done.
  - I would also recommend to resize your prior to doing this as well. The less amount of bytes an image contains the faster it loads for the client, and they usually do not need to be large for high quality rendering.

<b>How to call it</b>

- `sudo bash ./ConvertFiles.sh bucket="somebucketname"`

<b>Options</b>

- None

<b>What you'll see in the console</b>

- Some text that says `Newly converted files:`
  - Then it `ls`'s the files.
- That's it.

<b>What to know</b>

- You now have `jp2` and `webp` images of your previous images. Also, if your image was a `png`, you now have a `jpg` and vice versa.

<br />

#### `MoveImagesToS3.sh`

This moves your images to the an S3bucket of choice.

How to call it

- `sudo bash ./MoveImagesToS3.sh bucket="somebucketname"`

<b>Options</b>

- `bucket="somebucketname"`
  - Required

<b>What you'll see in the console

- A bunch of text like this (corresponding to how many files you have to write to s3): `upload: ./duck.jp2 to s3://somebucketname/jp2Images/duck.jp2`
  - This comes from the AWS cli.
- A message of how to check the images. With your url, like this: `This is the url to see the images
- Then the url: `https://somebucketname.s3.amazonaws.com/some-extension`
- And this: `some-extension is the path and filename, something like fallback/someImage.jpg.`
- And lastly this: `ie. https://somebucketname.s3.amazonaws.com/fallback/someImage.jpg`

<br />

#### And that's the gist

<br />

#### And now for something completely different

![](https://media.giphy.com/media/b9QBHfcNpvqDK/giphy.gif)
