// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import CheckboxSelectAll from 'stimulus-checkbox-select-all'
import TextareaAutogrow from 'stimulus-textarea-autogrow'

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import WidgetController from "./widget_controller"
application.register("widget", WidgetController)

import CheckboxController from "./checkbox_controller"
application.register("checkbox", CheckboxController)

application.register('checkbox-select-all', CheckboxSelectAll)
application.register('textarea-autogrow', TextareaAutogrow)