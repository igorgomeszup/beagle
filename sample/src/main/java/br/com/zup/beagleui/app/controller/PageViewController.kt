package br.com.zup.beagleui.app.controller

import br.com.zup.beagleui.framework.widget.core.Alignment
import br.com.zup.beagleui.framework.widget.core.Flex
import br.com.zup.beagleui.framework.widget.core.JustifyContent
import br.com.zup.beagleui.framework.widget.core.Widget
import br.com.zup.beagleui.framework.widget.layout.FlexSingleWidget
import br.com.zup.beagleui.framework.widget.layout.PageView
import br.com.zup.beagleui.framework.widget.ui.PageIndicator
import br.com.zup.beagleui.framework.widget.ui.Text
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class PageViewController {

    @RequestMapping("/pageView")
    fun getPageView(): Widget {
        return PageView(
            pageIndicator = PageIndicator(
                selectedColor = "#FFFFFF",
                unselectedColor = "#888888"
            ),
            pages = listOf(
                FlexSingleWidget(
                    flex = Flex(
                        justifyContent = JustifyContent.CENTER,
                        alignItems = Alignment.CENTER
                    ),
                    child = Text("Page 1")
                ),
                FlexSingleWidget(
                    flex = Flex(
                        justifyContent = JustifyContent.CENTER,
                        alignItems = Alignment.CENTER
                    ),
                    child = Text("Page 2")
                ),
                FlexSingleWidget(
                    flex = Flex(
                        justifyContent = JustifyContent.CENTER,
                        alignItems = Alignment.CENTER
                    ),
                    child = Text("Page 3")
                ),
                FlexSingleWidget(
                    flex = Flex(
                        justifyContent = JustifyContent.CENTER,
                        alignItems = Alignment.CENTER
                    ),
                    child = Text("Page 4")
                ),
                FlexSingleWidget(
                    flex = Flex(
                        justifyContent = JustifyContent.CENTER,
                        alignItems = Alignment.CENTER
                    ),
                    child = Text("Page 5")
                )
            )
        )
    }
}