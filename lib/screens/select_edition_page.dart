import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:daily_quran/screens/home_screen.dart';
import 'package:daily_quran/utils/language_util.dart';
import 'package:daily_quran/utils/pref_util.dart';
import 'package:flutter/material.dart';

import '../models/edition_model.dart';

class SelectEditionPage extends StatefulWidget {
  const SelectEditionPage({super.key});

  @override
  State<SelectEditionPage> createState() => _SelectEditionPageState();
}

class _SelectEditionPageState extends State<SelectEditionPage> {
  late PrefUtil prefUtil;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefUtil = PrefUtil();
    prefUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: const Center(child: Text('Select Edition')),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));

      }, child: const Icon(Icons.arrow_forward),),
      body: FutureBuilder(
        future:  QuranRepository().fetchEditions(),
        builder: (BuildContext context , AsyncSnapshot<List<EditionModel>> data){



          if(data.data == null || (data.data ?? []).isEmpty)
            {
              return const Center(child:  CircularProgressIndicator());
            }
          else {
            return ListView.builder(
               itemCount: data.data?.length,

                itemBuilder: (BuildContext context, int index) {

              EditionModel? model = data.data?[index];

              bool isSelected = model?.identifier == prefUtil.getIdentifier();
              return Material(
                child: Opacity(
                  opacity: isSelected? 1: 0.8,
                  child: Container(

                    decoration: BoxDecoration(

                        color: isSelected ? Styles.selectionBGColor : Colors.transparent,

                        border: Border.all(width: 1,color: Styles.selectionBGColor),
                          borderRadius: BorderRadius.circular(10)
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(

                      //splashColor: const Color(0xFFe5ccff),
                      splashColor: Styles.selectionBGColor,

                    selectedColor:Colors.black ,
                    onTap: () async {
                        //print('mode $model');

                        print('identifier ${model?.identifier}');
                        await prefUtil.updateIdentifier(model?.identifier);
                        setState(() {

                        });
                    },

                      selected:  model?.identifier == prefUtil.getIdentifier(),
                      title: Text(model?.englishName ?? '',style: Styles.getSelectionStyle(context),),
                      subtitle: Row(
                        children: [
                          Text('${LanguageUtil().getLanguageName(model?.language)} ',style: const TextStyle(color: Colors.blueAccent),),
                          Text(' | ${model?.type?.capitalizeFirstLetter() ?? ''} ',style: TextStyle(color: Colors.white),),
                        ],
                      ),


                    ),
                  ),
                ),
              );
            });

          }

        },
      ),
    );



  }
}



