#!/usr/bin/env bash 
export PATH=$PATH:/usr/local/bin

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}
bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}
rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}

if [[ $(id -u) != 0 ]]; then
yellow " 请以root模式运行脚本。"
rm -f CFwarp.sh
exit 0
fi

if [[ -f /etc/redhat-release ]]; then
release="Centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
release="Debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
elif cat /proc/version | grep -q -E -i "debian"; then
release="Debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
fi

if ! type curl >/dev/null 2>&1; then 
if [ $release = "Centos" ]; then
yellow "curl 未安装，安装中 "
yum -y update && yum install curl -y
else
apt update -y && apt install curl -y
fi	   
else
green "curl 已安装，继续 "
fi

if ! type wget >/dev/null 2>&1; then 
if [ $release = "Centos" ]; then
yellow "curl wget，安装中 "
yum -y update && yum install wget -y
else
apt update -y && apt install wget -y
fi	   
else
green "wget 已安装，继续 "
fi
  
sleep 1s
yellow "等待2秒……检测vps中……"
bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
rv4=`ip a | grep global | awk 'NR==1 {print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`
op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`hostnamectl | grep -i Virtualization | awk -F ':' '{print $2}'`
AE="阿联酋";AU="澳大利亚";BR="巴西";CA="加拿大";CH="瑞士";CL="智利";CN="中国";DE="德国";ES="西班牙";FI="芬兰";FR="法国";HK="香港";ID="印尼";IE="爱尔兰";IL="以色列";IN="印度";IT="意大利";JP="日本";KR="韩国";MY="马来西亚";NL="荷兰";NZ="新西兰";PH="菲律宾";RU="俄罗斯";SA="沙特";SE="瑞典";SG="新加坡";TW="台湾";UK="英国";US="美国";VN="越南";ZA="南非"

v44=`wget -T1 -t1 -qO- -4 ip.gs`
if [[ -n ${v44} ]]; then
gj4=`curl -s4 https://ip.gs/country-iso`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 

v66=`wget -T1 -t1 -qO- -6 ip.gs`
if [[ -n ${v66} ]]; then 
gj6=`curl -s6 https://ip.gs/country-iso`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

ud4='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud6='sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud4ud6='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
c1="sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf"
c2="sed -i '/\:\:\/0/d' wgcf-profile.conf"
c3="sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf"
c4="sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf"
c5="sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf"
c6="sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf"

Print_ALL_Status_menu() {
white "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
yellow " VPS相关信息如下："
blue " 操作系统名称 -$op "
blue " 系统内核版本 - $version " 
blue " CPU架构名称  - $bit "
blue " 虚拟架构类型 -$vi "
white "------------------------------------------"
blue " WARP状态+IPv4地址+IP所在区域: ${WARPIPv4Status}"
blue " WARP状态+IPv6地址+IP所在区域: ${WARPIPv6Status}"
white "------------------------------------------"
}

function ins(){
wg-quick down wgcf >/dev/null 2>&1
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf

if [[ ${vi} == " lxc" || ${vi} == " OpenVZ" ]]; then
tun=$(lsmod | grep tun | awk 'NR==1 {print $1}')
if [[ -n ${tun} ]]; then
case ${tun} in 
tun)
green "经检测，已开启TUN，安装wireguard-go模式的WARP(+)"
esac
else
red "你的lxc或者openvz小鸡未开启TUN，无法启动warp(+)，自动退出"
exit 0
fi
fi

if [[ ${vi} == " lxc" ]]; then
if [ $release = "Centos" ]; then
echo -e nameserver 2001:67c:2960:6464:6464:6464:6464:6464 > /etc/resolv.conf
fi
fi

if [ $release = "Centos" ]; then  
yum -y install epel-release
yum -y install curl net-tools wireguard-tools	
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then
if [[ ${vi} == " kvm" || ${vi} == " xen" || ${vi} == " microsoft" ]]; then
curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
yum -y install epel-release wireguard-dkms
fi
fi	
yum -y update

elif [ $release = "Debian" ]; then
apt update -y 
apt -y install lsb-release
echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | tee /etc/apt/sources.list.d/backports.list
apt update -y
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools               		
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then
if [[ ${vi} == " kvm" || ${vi} == " xen" || ${vi} == " microsoft" ]]; then
apt -y --no-install-recommends install linux-headers-$(uname -r);apt -y --no-install-recommends install wireguard-dkms
fi
fi		
apt update -y
	
elif [ $release = "Ubuntu" ]; then
apt update -y  
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools			
else 
red " 不支持你当前系统，请选择Ubuntu,Debain,Centos系统 "
rm -f CFwarp.sh
exit 1
fi
	
if [[ ${bit} == "x86_64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/wgcf-amd -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf         
elif [[ ${bit} == "aarch64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/wgcf-arm -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf
fi
if [[ ${vi} == " lxc" || ${vi} == " OpenVZ" ]]; then
wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/wireguard-go -O /usr/bin/wireguard-go && chmod +x /usr/bin/wireguard-go
fi

mkdir -p /etc/wireguard/ >/dev/null 2>&1
yellow "执行过程可能会多次提示429 Too Many Requests，请耐心等待。"
echo | wgcf register
until [[ -e wgcf-account.toml ]]
do
sleep 1s
echo | wgcf register
done

read -p "继续使用原WARP账户请“回车”跳过/启用WARP+PLUS账户，请复制WARP+的按键许可证秘钥(26个字符):" ID
if [[ -n $ID ]]; then
sed -i "s/license_key.*/license_key = \"$ID\"/g" wgcf-account.toml
wgcf update
green "启用WARP+PLUS账户中……如提示400 bad request，则使用原WARP账户,相关原因请看本项目Github说明" 
fi
wgcf generate

echo $ABC1 | sh
echo $ABC2 | sh
echo $ABC3 | sh
echo $ABC4 | sh

mv -f wgcf-profile.conf /etc/wireguard/wgcf.conf
mv -f wgcf-account.toml /etc/wireguard/wgcf-account.toml

wg-quick up wgcf >/dev/null 2>&1
v4=$(wget -T1 -t1 -qO- -4 ip.gs)
v6=$(wget -T1 -t1 -qO- -6 ip.gs)
until [[ -n $v4 || -n $v6 ]]
do
wg-quick down wgcf >/dev/null 2>&1
wg-quick up wgcf >/dev/null 2>&1
v4=$(wget -T1 -t1 -qO- -4 ip.gs)
v6=$(wget -T1 -t1 -qO- -6 ip.gs)
done

systemctl enable wg-quick@wgcf >/dev/null 2>&1
wg-quick down wgcf >/dev/null 2>&1
systemctl restart wg-quick@wgcf

yellow "设置重启VPS时，自动刷新WARP功能"
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/sp.sh >/dev/null 2>&1
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if [ ${release} = "Centos" ]; then  
yum install vixie-cron crontabs >/dev/null 2>&1
chkconfig crond on >/dev/null 2>&1
systemctl start crond.service >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/root >/dev/null 2>&1
echo "@reboot /root/sp.sh >/dev/null 2>&1" >> /var/spool/cron/root
chmod 777 /var/spool/cron/root
crontab /var/spool/cron/root
systemctl restart crond.service
else
apt install cron >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/crontabs/root >/dev/null 2>&1
echo "@reboot /root/sp.sh >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
chmod 777 /var/spool/cron/crontabs/root
crontab /var/spool/cron/crontabs/root
systemctl restart cron.service
fi
green "设置完成"

grep -qE '^[ ]*label[ ]*2002::/16[ ]*2' /etc/gai.conf || echo 'label 2002::/16   2' | sudo tee -a /etc/gai.conf

v44=`wget -T1 -t1 -qO- -4 ip.gs`
if [[ -n ${v44} ]]; then
gj4=`curl -s4 https://ip.gs/country-iso`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 

v66=`wget -T1 -t1 -qO- -6 ip.gs`
if [[ -n ${v66} ]]; then 
gj6=`curl -s6 https://ip.gs/country-iso`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;;  
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

green "安装结束，当前WARP及IP状态如下 "
blue "WARP状态+IPv4地址+IP所在区域: ${WARPIPv4Status}"
blue "WARP状态+IPv6地址+IP所在区域: ${WARPIPv6Status}"
}

function warpip(){
chmod +x sp.sh && ./sp.sh
}

function warpplus(){
if [ $release = "Centos" ]; then
yum -y install python3
else 
apt -y install python3
fi
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/kkkyg/warp-plus/wp.py
python3 wp.py
}

function upcore(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/ucore.sh && chmod +x ucore.sh && ./ucore.sh
}

function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
if [[ ${vi} == " lxc" || ${vi} == " OpenVZ" ]]; then
red " 不支持当前VPS的架构，请使用KVM等主流架构的VPS "
sleep 2s
start_menu
else 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
green "安装原生BBR加速成功"
fi
}

function cwarp(){
systemctl disable wg-quick@wgcf >/dev/null 2>&1
wg-quick down wgcf >/dev/null 2>&1
if [ $release = "Centos" ]; then
yum -y autoremove wireguard-tools wireguard-dkms
else 
apt -y autoremove wireguard-tools wireguard-dkms
fi
sed -i '/sp.sh/d' /var/spool/cron/root >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/crontabs/root >/dev/null 2>&1
[[ -e /etc/gai.conf ]] && sed -i '/^precedence[ ]*::ffff:0:0\/96[ ]*100/d' /etc/gai.conf
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf sp.sh ucore.sh CFwarp.sh
green "WARP卸载完成"
}

function c1warp(){
wg-quick down wgcf
v44=`wget -T1 -t1 -qO- -4 ip.gs`
if [[ -n ${v44} ]]; then
gj4=`curl -s4 https://ip.gs/country-iso`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 
v66=`wget -T1 -t1 -qO- -6 ip.gs`
if [[ -n ${v66} ]]; then 
gj6=`curl -s6 https://ip.gs/country-iso`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;;  
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 
blue "WARP状态+IPv4地址+IP所在区域: ${WARPIPv4Status}"
blue "WARP状态+IPv6地址+IP所在区域: ${WARPIPv6Status}"
}

function owarp(){
wg-quick up wgcf
v44=`wget -T1 -t1 -qO- -4 ip.gs`
if [[ -n ${v44} ]]; then
gj4=`curl -s4 https://ip.gs/country-iso`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 
v66=`wget -T1 -t1 -qO- -6 ip.gs`
if [[ -n ${v66} ]]; then 
gj6=`curl -s6 https://ip.gs/country-iso`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;;  
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 
blue "WARP状态+IPv4地址+IP所在区域: ${WARPIPv4Status}"
blue "WARP状态+IPv6地址+IP所在区域: ${WARPIPv6Status}"
}

function macka(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
curl -fsSL https://cdn.jsdelivr.net/gh/phlinhng/v2ray-tcp-tls-web@main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}


function Netflix(){
if [[ ${bit} == "x86_64" ]]; then
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.61_linux_amd64 && chmod +x nf && clear && ./nf -method full      
elif [[ ${bit} == "aarch64" ]]; then
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.61_linux_arm64 && chmod +x nf && clear && ./nf -method full
fi
}

function up4(){
wget -N --no-check-certificate https://raw.githubusercontent.com/kkkyg/CFwarp/main/CFwarp.sh && chmod +x CFwarp.sh && ./CFwarp.sh
}

#主菜单
function start_menu(){
    clear
    bblue " 详细说明 https://github.com/kkkyg/CFwarp  YouTube频道：甬哥侃侃侃" 
    
    red " 切记：进入脚本快捷方式 bash CFwarp.sh "
    
    white " ==================一、VPS相关调整选择（更新中）==========================================" 
    
    green " 1.  永久开启甲骨文VPS的ubuntu系统所有端口 "
    
    green " 2.  为5.6以下系统内核更新至5.6以上 "
    
    green " 3.  开启原生BBR加速 "
    
    green " 4.  检测奈飞Netflix是否解锁 "
    
    white " ==================二、WARP功能选择（更新中）======================================"
    
    green " 5.  VPS纯IPV4        >> 添加WARP虚拟IPV4               "
    
    green " 6.  VPS纯IPV4        >> 添加WARP虚拟IPV6      "
    
    green " 7.  VPS纯IPV4        >> 添加WARP虚拟IPV4+虚拟IPV6              "
    white " ---------------------------------------------------------------------------------"   
    green " 8.  VPS纯IPV6        >> 添加WARP虚拟IPV4               "
    
    green " 9.  VPS纯IPV6        >> 添加WARP虚拟IPV6     "
    
    green " 10. VPS纯IPV6        >> 添加WARP虚拟IPV4+虚拟IPV6               " 
    white " ---------------------------------------------------------------------------------"
    green " 11. VPS双栈IPV4+IPV6 >> 添加WARP虚拟IPV4               "
    
    green " 12. VPS双栈IPV4+IPV6 >> 添加WARP虚拟IPV6      "
    
    green " 13. VPS双栈IPV4+IPV6 >> 添加WARP虚拟IPV4+虚拟IPV6               "
    
    white " ---------------------------------------------------------------------------------"
    
    green " 14. 获取WARP+账户无限刷流量 "
    
    green " 15. 手动刷新WARP的IP(WARP防失联)"
    
    green " 16. 卸载WARP功能 "
    
    green " 17. 临时关闭WARP功能 "
    
    green " 18. 临时关闭后开启WARP功能 "
    
    white " ==================三、代理协议脚本选择（更新中）==========================================="
    
    green " 19.使用mack-a脚本（支持Xray, V2ray） "
    
    green " 20.使用phlinhng脚本（支持Xray, Trojan-go, SS+v2ray-plugin） "
    
    white " ============================================================================================="
    
    red " 0. 退出脚本 "
    Print_ALL_Status_menu
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in     
        1 )
           iptables
	;;
        2 )
           upcore
	;;
        3 )
           BBR
	;;
	4 )
           Netflix
	;;    
        5 )
           ABC1=${ud4} && ABC2=${c3} && ABC3=${c2} && ABC4=${c5}; ins
	;;
        6 )
           ABC1=${c3} && ABC2=${c1} && ABC3=${c5}}; ins
	;;
        7 )
           ABC1=${ud4} && ABC2=${c3} && ABC3=${c5}; ins
	;;
        8 )
           ABC1=${c4} && ABC2=${c2} && ABC3=${c5}; ins
	;;
        9 )
           ABC1=${ud6} && ABC2=${c1} &&ABC3=${c4} ABC4=${c6}; ins
	;;
	10 )   
	   ABC1=${ud6} && ABC2=${c4} && ABC3=${c5}; ins
	;;
	11 )
           ABC1=${ud4} && ABC2=${c2} && ABC3=${c5}; ins
	;;
	12 )
           ABC1=${ud6} && ABC2=${c1} && ABC3=${c5}; ins
	;;
	13 )
           ABC1=${ud4ud6} && ABC2=${c5}; ins
	;;
	14 )
           warpplus
	;;
	15 )
           warpip
	;;	
	16 )
           cwarp
	;;
	17 )
           c1warp
	;;
	18 )
           owarp
	;;
	19 )
           macka
	;;
	20 )
           phlinhng
	;;
        0 )
           exit 1
        ;;
  esac
}

start_menu "first"