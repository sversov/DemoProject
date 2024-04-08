# DemoProject

Demo project to demonstrate knowledge and experience as an iOS engineer.

Architecture used in the project: MVVM+C (Model View ViewModel + Coordinators)

The network layer implementation is naive and simplistic for the purpose of demonstration that any Network Library or custom implementation could be used instead.

There are few improvements that could be made: 
- Image downloading: instead of using AsyncImage we could implement custom ImageLoader with Caching.
- Improve testing strategy by adding more tests like UI and Snapshot tests.
- Separate common Views into their own files. 
- Improve testability of ApplicationCoordinator

