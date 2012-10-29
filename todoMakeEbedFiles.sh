
cd ..

eventSourceName=burgeEvent
bedSeqSeqDir=/lab/solexa_jaenisch/jaenisch_albert/genomes/mm9/seq/

for i in *.gff3; do
eventType=${i/.gff3/}
echo processing $eventType
rm $eventType.ebed
echo "track name='$eventSourceName:$eventType' description='$eventSourceName:$eventType' itemRgb=On visibility=pack"  > $eventType.ebed
gff3ToEBed.py --outGeneList $eventType.eventNames --itemRGB "@@@@@'255,0,0' if name[-1]=='A' else '0,0,255'" $i >> $eventType.ebed

rm $eventType.ID2EventName
awk -v FS="\t" -v OFS="\t" -v eventSourceName=$eventSourceName -v eventType=$eventType 'BEGIN{printf("eventID\tevent_name\n");}{printf("%s:%s:%d\t%s\n",eventSourceName,eventType,FNR,$1);}' $eventType.eventNames > $eventType.ID2EventName

rm $eventType.IDi2EventNamei
awk -v FS="\t" -v OFS="\t" '{if(FNR==1){print;}else{printf("%s.1\t%s.A\n%s.2\t%s.B\n",$1,$2,$1,$2);}}' $eventType.ID2EventName > $eventType.IDi2EventNamei

rm $eventType.gb.ebed.00 $eventType.gb.ebed

joinu.py -w 2 -1 2 -2 4 $eventType.IDi2EventNamei $eventType.ebed > $eventType.gb.ebed.00

echo "track name='$eventSourceName:$eventType' description='$eventSourceName:$eventType' itemRgb=On visibility=pack"  > $eventType.gb.ebed
cuta.py -f3-5,1,6-_1 $eventType.gb.ebed.00 >> $eventType.gb.ebed

bedSeq /lab/solexa_jaenisch/jaenisch_albert/genomes/mm9/seq/ $eventType.gb.ebed ebed --seq-block-sep "|" > $eventType.gb.ebedseq

#clean up
rm $eventType.eventNames
rm $eventType.gb.ebed.00

done


