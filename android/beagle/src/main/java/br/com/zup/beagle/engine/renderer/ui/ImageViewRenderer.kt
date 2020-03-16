package br.com.zup.beagle.engine.renderer.ui

import android.view.View
import android.widget.ImageView
import br.com.zup.beagle.engine.mapper.ViewMapper
import br.com.zup.beagle.engine.renderer.RootView
import br.com.zup.beagle.engine.renderer.UIViewRenderer
import br.com.zup.beagle.setup.BeagleEnvironment
import br.com.zup.beagle.view.ViewFactory
import br.com.zup.beagle.widget.core.ImageContentMode
import br.com.zup.beagle.widget.ui.Image

internal class ImageViewRenderer(
    override val component: Image,
    private val viewFactory: ViewFactory = ViewFactory(),
    private val viewMapper: ViewMapper = ViewMapper()
) : UIViewRenderer<Image>() {

    override fun buildView(rootView: RootView): View {
        return viewFactory.makeImageView(rootView.getContext()).apply {
            setData(component, viewMapper)
        }
    }

    private fun ImageView.setData(widget: Image, viewMapper: ViewMapper) {
        val contentMode = widget.contentMode ?: ImageContentMode.FIT_CENTER
        scaleType = viewMapper.toScaleType(contentMode)
        val designSystem = BeagleEnvironment.beagleSdk.designSystem
        if (designSystem != null) {
            val image = designSystem.image(widget.name)
            this.setImageResource(image)
        }
    }
}
