set ns [new Simulator]

set nam [open out.nam w]
$ns namtrace-all $nam

set tr [open out.tr w]
$ns trace-all $tr

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 1Mb 20ms DropTail
$ns queue-limit $n0 $n2 5
$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns duplex-link $n2 $n3 1Mb 20ms DropTail
$ns duplex-link $n3 $n4 1Mb 20ms DropTail
$ns duplex-link $n3 $n5 1Mb 20ms DropTail

Agent/TCP set_nam_tracevar_true

set tcp [new Agent/TCP]
$tcp set fid 1

$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]

$ns attach-agent $n4 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc finish {} {
global ns tr nam
$ns flush-trace
close $tr
close $nam
exec nam out.nam &
exit 0
}

$ns at 0.05 "$ftp start"
#$ns at 0.06 "$tcp set windowlnit 6"
#$ns at 0.06 "$tcp set maxcwnd 6"
$ns at 0.25 "$ns queue-limit $n3 $n4 0"
$ns at 0.26 "$ns queue-limit $n3 $n4 5"
#$ns at 0.305 "$tcp set windowlnit 4"
#$ns at 0.305 "$tcp set maxcwnd 4"
$ns at 1.5 "finish"
$ns run
