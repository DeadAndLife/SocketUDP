/*
 *UDP/IP应用编程接口（API）
 *服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机
 *地址以及一个本地端口号绑定，接收到一个客户端时，服务器显示该客户端的IP地址，并将字串
 *返回给客户端。
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#import <arpa/inet.h>
int main(int argc,char **argv)
{
    int ser_sockfd;//socket，文件描述符
    
    //int addrlen;
    socklen_t addrlen;//socket地址长度
    
    struct sockaddr_in ser_addr;//socket地址
    /*建立socket*/
    ser_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(ser_sockfd<0)
    {
        printf("I cannot socket success\n");
        return 1;
    }
    
    
    /*填写sockaddr_in 结构*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&ser_addr,addrlen);//初始化地址
    ser_addr.sin_family=AF_INET;
    ser_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    ser_addr.sin_port=htons(1024);
    /*绑定客户端*/
    if(bind(ser_sockfd,(struct sockaddr *)&ser_addr,addrlen)<0)
    {
        printf("connect");
        return 1;
    }
    
    
    //接受内容
    while(1)
    {
        char content[100];
        bzero(content,sizeof(content));//初始化内容
        size_t len;//长度
        len=recvfrom(ser_sockfd,content,sizeof(content),0,(struct sockaddr*)&ser_addr,&addrlen);//接受客户端发送的内容,以及客户端的地址(ser_addr)
        /*显示client端的网络地址*/
        printf("receive from %s\n",inet_ntoa(ser_addr.sin_addr));
        /*显示客户端发来的字串*/
        printf("recevce:%s",content);
        /*将字串返回给client端*/
        sendto(ser_sockfd,content,len,0,(struct sockaddr*)&ser_addr,addrlen);
    }
}
