package br.com.zup.beagle.sample.service

import br.com.zup.beagle.action.ShowNativeDialog
import br.com.zup.beagle.sample.constants.PATH_LAZY_COMPONENT_ENDPOINT
import br.com.zup.beagle.widget.core.Alignment
import br.com.zup.beagle.widget.core.Flex
import br.com.zup.beagle.widget.core.JustifyContent
import br.com.zup.beagle.widget.layout.Container
import br.com.zup.beagle.widget.layout.NavigationBar
import br.com.zup.beagle.widget.layout.NavigationBarItem
import br.com.zup.beagle.widget.layout.Screen
import br.com.zup.beagle.widget.lazy.LazyComponent
import br.com.zup.beagle.widget.ui.Text
import org.springframework.stereotype.Service


@Service
class SampleLazyComponentService {
    fun createLazyComponent(): Screen {
        return Screen(
            navigationBar = NavigationBar(
                "Beagle LazyComponent",
                showBackButton = true,
                navigationBarItems = listOf(
                    NavigationBarItem(
                        text = "",
                        image = "informationImage",
                        action = ShowNativeDialog(
                            title = "Lazy Component",
                            message = "A widget that implements loading.",
                            buttonText = "OK"
                        )
                    )
                )
            ),
            child = Container(
                children = listOf(
                    LazyComponent(
                        path = PATH_LAZY_COMPONENT_ENDPOINT,
                        initialState = Text("Loading...").applyFlex(
                            flex = Flex(
                                justifyContent = JustifyContent.CENTER,
                                alignSelf = Alignment.CENTER
                            )
                        )
                    )
                )
            )
        )
    }
     fun createTextLazyComponent(): Text {
         return Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do " +
             "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud" +
             " exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in " +
             "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat " +
             "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
     }
}
