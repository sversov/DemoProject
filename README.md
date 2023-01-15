# DemoProject
This is a demo project to demonstrate knowledge and experiece as iOS engineer.

Architecture used in the project: MVVM+C (Model View ViewModel + Coordinators)

The network layer implementation is naive and simplistic on purpose to demonstrate that any Network Library or custom implementation could be used instead.

There are few improvements that could be made to the project if neccessary: 
- Image downloading instead of using AsyncImage we could implement custom ImageLoader with Caching (AsyncImage althoug is good in some cases , has few issues, especially when used inside Swift UI List view)
- Decouple UIKit Navigation.
- Improve testing strategy by adding more tests like UI and Snapshot tests.

