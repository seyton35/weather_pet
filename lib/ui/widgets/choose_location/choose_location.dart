import 'package:flutter/material.dart';

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: size.width,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'отмена',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
