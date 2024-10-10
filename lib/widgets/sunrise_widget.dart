import 'package:flutter/material.dart';

class SunriseWidget extends StatelessWidget {
  const SunriseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          height: 100,
          width: 340,
          decoration: BoxDecoration(
            color: Color(0xFF3CCF3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/sunrise.png'))),
                    ),
                   const  SizedBox(
                      width: 15,
                    ),
                     const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sunrise',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            '5:45 AM',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
               const Spacer(),
               const Text(
                  '4 hours ago',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
