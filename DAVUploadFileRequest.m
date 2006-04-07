/*
 Copyright (c) 2004-2006, Greg Hulands <ghulands@framedphotographics.com>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, 
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list 
 of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this 
 list of conditions and the following disclaimer in the documentation and/or other 
 materials provided with the distribution.
 
 Neither the name of Greg Hulands nor the names of its contributors may be used to 
 endorse or promote products derived from this software without specific prior 
 written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
 BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY 
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DAVUploadFileRequest.h"


@implementation DAVUploadFileRequest

- (id)initWithData:(NSData *)data filename:(NSString *)filename
{
	if (![filename hasPrefix:@"/"])
	{
		filename = [NSString stringWithFormat:@"/%@", filename];
	}
	
	if (self = [super initWithMethod:@"PUT" uri:filename])
	{
		myFilename = [filename copy];
		[self setContent:data];
		[self setHeader:@"application/octet-stream" forKey:@"Content-Type"];
	}
	return self;
}

- (id)initWithFile:(NSString *)local filename:(NSString *)remote
{
	if (![remote hasPrefix:@"/"])
	{
		remote = [NSString stringWithFormat:@"/%@", remote];
	}
	
	if (self = [super initWithMethod:@"PUT" uri:remote])
	{
		myLocalFilename = [local copy];
		myFilename = [remote copy];
		[self setHeader:@"application/octet-stream" forKey:@"Content-Type"];
	}
	return self;
}

+ (id)uploadWithData:(NSData *)data filename:(NSString *)filename
{
	return [[[DAVUploadFileRequest alloc] initWithData:data filename:filename] autorelease];
}

+ (id)uploadWithFile:(NSString *)localFile filename:(NSString *)filename
{
	return [[[DAVUploadFileRequest alloc] initWithFile:localFile filename:filename] autorelease];
}

- (void)dealloc
{
	[myLocalFilename release];
	[myFilename release];
	[super dealloc];
}

- (NSString *)remoteFile
{
	return myFilename;
}

- (NSData *)serialized
{
	// load the file data at the latest possible time.
	if (myLocalFilename && [myContent length] == 0)
	{
		NSData *data = [NSData dataWithContentsOfFile:myLocalFilename];
		[self setContent:data];
	}
	return [super serialized];
}

@end