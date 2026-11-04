import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const ArcApp());

class ArcApp extends StatefulWidget {
  const ArcApp({super.key});
  @override State<ArcApp> createState() => _ArcAppState();
}

class _ArcAppState extends State<ArcApp> {
  ThemeMode mode = ThemeMode.dark;
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'ARC', debugShowCheckedModeBanner: false, themeMode: mode,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff7969d8), brightness: Brightness.light), useMaterial3: true),
    darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffa99aff), brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xff101018), useMaterial3: true),
    home: ArcHome(onTheme: () => setState(() => mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark)),
  );
}

class ArcNote { String id, title, body; ArcNote(this.id,this.title,this.body); Map<String,dynamic> toJson()=>{'id':id,'title':title,'body':body}; factory ArcNote.fromJson(Map<String,dynamic> j)=>ArcNote(j['id'],j['title'],j['body']); }

class ArcHome extends StatefulWidget {
  final VoidCallback onTheme; const ArcHome({super.key,required this.onTheme});
  @override State<ArcHome> createState()=>_ArcHomeState();
}
class _ArcHomeState extends State<ArcHome> {
  final title=TextEditingController(); final body=TextEditingController(); final search=TextEditingController();
  List<ArcNote> notes=[]; String? selected; bool loading=true;
  @override void initState(){super.initState();load();}
  Future<void> load() async {final p=await SharedPreferences.getInstance();final raw=p.getString('arc.notes');if(raw!=null){notes=(jsonDecode(raw) as List).map((e)=>ArcNote.fromJson(e)).toList();}if(notes.isEmpty){notes=[ArcNote('welcome','Welcome to ARC','# Your ideas, connected.\n\nCapture a thought, give it a title, and come back to it later.')];}selected=notes.first.id;syncFields();setState(()=>loading=false);}
  void syncFields(){final n=notes.firstWhere((n)=>n.id==selected,orElse:()=>notes.first);title.text=n.title;body.text=n.body;}
  Future<void> save() async {final n=notes.firstWhere((n)=>n.id==selected);n.title=title.text;n.body=body.text;final p=await SharedPreferences.getInstance();await p.setString('arc.notes',jsonEncode(notes.map((n)=>n.toJson()).toList()));setState((){});}
  void add(){final n=ArcNote(DateTime.now().microsecondsSinceEpoch.toString(),'Untitled','# Untitled\n\nStart writing…');setState(()=>notes.insert(0,n));selected=n.id;syncFields();save();}
  @override Widget build(BuildContext context){final visible=notes.where((n)=>n.title.toLowerCase().contains(search.text.toLowerCase())).toList();return Scaffold(appBar:AppBar(title:const Text('arc.',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:-1)),actions:[IconButton(onPressed:widget.onTheme,icon:const Icon(Icons.brightness_6_outlined)),IconButton(onPressed:add,icon:const Icon(Icons.add))]),body:loading?const Center(child:CircularProgressIndicator()):LayoutBuilder(builder:(context,c)=>c.maxWidth<700?Column(children:[Expanded(child:noteList(visible)),if(selected!=null)Expanded(flex:2,child:editor())]):Row(children:[SizedBox(width:280,child:noteList(visible)),Expanded(child:editor())])),);}
  Widget noteList(List<ArcNote> visible)=>Column(children:[Padding(padding:const EdgeInsets.all(12),child:TextField(controller:search,decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search notes',border:OutlineInputBorder()),onChanged:(_)=>setState((){}))),Expanded(child:ListView.builder(itemCount:visible.length,itemBuilder:(context,i){final n=visible[i];return ListTile(selected:n.id==selected,leading:const Icon(Icons.description_outlined),title:Text(n.title,maxLines:1,overflow:TextOverflow.ellipsis),onTap:(){setState(()=>selected=n.id);syncFields();});}))]);
  Widget editor()=>Padding(padding:const EdgeInsets.all(20),child:Column(children:[TextField(controller:title,style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold),decoration:const InputDecoration(border:InputBorder.none,hintText:'Note title'),onChanged:(_)=>save()),const SizedBox(height:12),Expanded(child:TextField(controller:body,maxLines:null,expands:true,textAlignVertical:TextAlignVertical.top,decoration:const InputDecoration(border:InputBorder.none,hintText:'Start writing…'),onChanged:(_)=>save())),const Align(alignment:Alignment.centerLeft,child:Text('Saved on this device',style:TextStyle(fontSize:11,color:Colors.grey))) ]));
  @override void dispose(){title.dispose();body.dispose();search.dispose();super.dispose();}
}
