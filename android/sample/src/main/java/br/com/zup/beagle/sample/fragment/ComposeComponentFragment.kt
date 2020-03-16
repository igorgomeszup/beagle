package br.com.zup.beagle.sample.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import br.com.zup.beagle.core.ServerDrivenComponent
import br.com.zup.beagle.sample.widgets.TextField
import br.com.zup.beagle.sample.widgets.TextFieldInputType
import br.com.zup.beagle.utils.toView
import br.com.zup.beagle.widget.core.ComposeComponent
import br.com.zup.beagle.widget.core.EdgeValue
import br.com.zup.beagle.widget.core.Flex
import br.com.zup.beagle.widget.core.JustifyContent
import br.com.zup.beagle.widget.core.Size
import br.com.zup.beagle.widget.core.UnitType
import br.com.zup.beagle.widget.core.UnitValue
import br.com.zup.beagle.widget.form.Form
import br.com.zup.beagle.widget.form.FormInput
import br.com.zup.beagle.widget.form.FormMethodType
import br.com.zup.beagle.widget.form.FormSubmit
import br.com.zup.beagle.widget.layout.Container
import br.com.zup.beagle.widget.ui.Button

class ComposeComponentFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val declarative = ComposeFormName()

        return declarative.toView(this)
    }

    companion object {
        fun newInstance(): ComposeComponentFragment {
            return ComposeComponentFragment()
        }
    }
}

class ComposeFormName : ComposeComponent() {
    override fun build(): ServerDrivenComponent {
        return Form(
            path = "/validate-name",
            method = FormMethodType.POST,
            child = Container(
                children = listOf(
                    buildContent(),
                    buildFooter()
                )
            ).applyFlex(
                flex = Flex(
                    justifyContent = JustifyContent.SPACE_BETWEEN,
                    grow = 1.0
                )
            )
        )
    }

    private fun buildContent() = Container(
        children = listOf(
            FormInput(
                name = "name",
                child = TextField(
                    description = "digite seu nome",
                    hint = "nome",
//                color = "#FFFFFF",
                    inputType = TextFieldInputType.TEXT
                )
            )
        )
    ).applyFlex(
        flex = Flex(
            size = Size(
                width = UnitValue(
                    value = 100.0,
                    type = UnitType.PERCENT
                )
            ),
            margin = EdgeValue(
                all = UnitValue(
                    value = 15.0,
                    type = UnitType.REAL
                )
            )
        )
    )

    private fun buildFooter() = Container(
        children = listOf(
            (FormSubmit(
                child = Button("cadastrar", style = "primaryButton")
            ))
        )
    ).applyFlex(
        flex = Flex(
            size = Size(
                width = UnitValue(
                    value = 100.0,
                    type = UnitType.PERCENT
                )
            ),
            padding = EdgeValue(
                left = UnitValue(
                    value = 15.0,
                    type = UnitType.REAL
                ),
                right = UnitValue(
                    value = 15.0,
                    type = UnitType.REAL
                ),
                bottom = UnitValue(
                    value = 15.0,
                    type = UnitType.REAL
                )
            )
        )
    )
}
