//
//  main.m
//  UDPSocketClint
//
//  Created by Xionghaizi on 16/6/7.
//  Copyright © 2016年 Xionghaizi. All rights reserved.
//
/*
 *UDP/IP应用编程接口（API）
 *客户端的工作流程：首先调用socket函数创建一个Socket，填写服务器地址及端口号，
 *从标准输入设备中取得字符串，将字符串传送给服务器端，并接收服务器端返回的字
 *符串。最后关闭该socket。
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#import <unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include <netinet/in.h>
#import <arpa/inet.h>
int GetServerAddr(char * addrname)
{
    printf("please input server addr:");
    scanf("%s",addrname);
    return 1;
}
int main(int argc,char **argv)
{
    int cli_sockfd;//socket
    size_t len;//sizen
    socklen_t addrlen;//socket addr len
    char seraddr[14];//service ip
   
    
    GetServerAddr(seraddr);
    /* 建立socket*/
    cli_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    
    if(cli_sockfd<0)
    {
        printf("I cannot socket success\n");
        return 1;
    }
    
    //创建socket地址,设置为服务器的地址
    struct sockaddr_in ser_addr;// ser socket addr
    /* 填写sockaddr_in*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&ser_addr,addrlen);
    ser_addr.sin_family=AF_INET;
    ser_addr.sin_addr.s_addr=inet_addr(seraddr);
    //cli_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    ser_addr.sin_port=htons(1024);
    
    
    char buffer[256];
    bzero(buffer,sizeof(buffer));//初始化一个榕溪
    /* 从标准输入设备取得字符串*/
    len=read(STDIN_FILENO,buffer,sizeof(buffer));//从终端输入内容
    /* 将字符串传送给server端*/
    sendto(cli_sockfd,buffer,len,0,(struct sockaddr*)&ser_addr,addrlen);//Socket 发送 buffer 长度为 len 发送的 地址是 ser_addr 地址长度addrlen
    /* 接收server端返回的字符串*/
    len=recvfrom(cli_sockfd,buffer,sizeof(buffer),0,(struct sockaddr*)&ser_addr,&addrlen);
//    sockefd 接受 buffer 长度 len  从 ser_addr 地址长度 addrlen;
    
    //printf("receive from %s\n",inet_ntoa(cli_addr.sin_addr));
    printf("receive: %s",buffer);
    close(cli_sockfd);
}
