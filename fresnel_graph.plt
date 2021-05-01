reset
set angle rad

#=================== Parameters ====================
N = int(5e3)       # If you integrate using Simpson's rule, N is even.
lineWidth = 1.5
trange = 15.       #[-trange:trange]

limitCenterX = sqrt(pi)/2
limitCenterY = sqrt(pi)/2

#=================== Functions ====================
# Integrands of Fresnel integrals
c(t) = cos(t**2)
s(t) = sin(t**2)

# Fresnel integral using composite Simpson's rule
fresnelC(t) = (h = t/N, h/3*(sum[i=1:N/2]c((2*i-2)*h)+4*c((2*i-1)*h)+c(2*i*h)))
fresnelS(t) = (h = t/N, h/3*(sum[i=1:N/2]s((2*i-2)*h)+4*s((2*i-1)*h)+s(2*i*h)))

#=================== Setting ====================
# set term pngcairo transparent truecolor enhanced dashed size 300, 225 font 'Times, 12' # for YouTube
set term pngcairo truecolor enhanced dashed size 600, 450 font 'Times, 12'
set key font ', 14' right bottom spacing 1.3 # default=1
set grid
set samples 5e3
set xr[-5:5]
set yr[-1:1]
# set xl '{/:Italic t}' offset screen 0, 0.03 font ', 14'
set xl '{/:Italic t}' font ', 14'
unset yl

#=================== Plot ====================
set output "fresnelCS.png"
plot fresnelC(x) w l lc rgb '0x0086C8' lw lineWidth t '{/:Italic C}({/:Italic t})', \
     fresnelS(x) w l lc rgb '0xFF5050' lw lineWidth t '{/:Italic S}({/:Italic t})'
set out
