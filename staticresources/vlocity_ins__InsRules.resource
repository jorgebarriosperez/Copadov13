(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var partsLength=parts.length-1;var thisScript=parts[partsLength--];if(thisScript===""){thisScript=parts[partsLength--]}if(scriptName.indexOf("__")!=-1){while(thisScript.indexOf("__")==-1&&partsLength>=0){thisScript=parts[partsLength];partsLength--}}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
angular.module('insDirectives', ['sldsangular']);

// Directives
require('./modules/insDirectives/directive/InsDropdownHandler.js');
require('./modules/insDirectives/directive/InsInclude.js');
},{"./modules/insDirectives/directive/InsDropdownHandler.js":3,"./modules/insDirectives/directive/InsInclude.js":4}],2:[function(require,module,exports){
var insRulesModule = angular.module('insRules', ['insDirectives', 'sldsangular', 'ngSanitize']);
// Not all the directives in this module need 'viaExpressionEngine', and so don't want to force
// those using this module to also add the VlocityExpressionEngine.resource to their page.
// Checking to see if it exists on the page first before adding it as a module dependency:
if (angular.element('script[src*="VlocityExpressionEngine"]').length) {
    insRulesModule.requires.push('viaExpressionEngine');
}
if (angular.element('script[src*="CardFramework"]').length || angular.element('script[src*="cardframework"]').length) {
    insRulesModule.requires.push('CardFramework');
}
insRulesModule.config(['remoteActionsProvider', function(remoteActionsProvider) {
    'use strict';
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}]).config(['$compileProvider', function ($compileProvider) {
    $compileProvider.debugInfoEnabled(true);
}]).config(['$sldsDatePickerProvider', function($sldsDatePickerProvider) {
    'use strict';
    angular.extend($sldsDatePickerProvider.defaults, {
        placement: 'bottom-right',
        dateType: 'iso',
        modelDateFormat: 'yyyy-MM-ddTHH:mm:ss.sssZ'
    });
}]).config(['$sldsTimePickerProvider', function($sldsTimePickerProvider) {
    'use strict';
    angular.extend($sldsTimePickerProvider.defaults, {
        placement: 'bottom-right',
        timeType: 'iso',
        modelTimeFormat: 'yyyy-MM-ddTHH:mm:ss.sssZ'
    });
}])
.run(['$rootScope', function($rootScope) {
    'use strict';
    $rootScope.nsPrefix = fileNsPrefix();
    $rootScope.isLoaded = false;
}]).run(['$templateCache', function($templateCache) {
    $templateCache.put("expression-engine-element-name.tpl.html",
        "<div class=\"via-slds vlocity\">"+
        "<ul class=\"typeahead dropdown-menu\" style=\"position: static; top: auto; left: auto; display: block;   float: none;\">"+
            "<li mentio-menu-item=\"item\" ng-repeat=\"item in items\">"+
                "<a class=\"text-primary\" ng-bind-html=\"item.label | mentioHighlight:typedTerm:'menu-highlighted' | unsafe\"></a>" +
            "</li>" +
        "</ul></div>");
}]);

// Dependencies
require('./InsDirectives.js');

// Directives
require('./modules/insRules/directive/InsRulesDefinitionDirective.js');
require('./modules/insRules/directive/InsRulesEvaluationDirective.js');
require('./modules/insRules/directive/InsRulesAttributesDisplayDirective.js');
require('./modules/insRules/directive/InsRulesCheckElement.js');
require('./modules/insRules/directive/InsRulesCalcHeight.js');

// Factory
require('./modules/insRules/factory/InsRulesValidationService.js');
require('./modules/insRules/factory/InsRulesDefinitionService.js');
require('./modules/insRules/factory/InsRulesEvaluationService.js');

// Templates
require('./modules/insRules/templates/templates.js');
},{"./InsDirectives.js":1,"./modules/insRules/directive/InsRulesAttributesDisplayDirective.js":5,"./modules/insRules/directive/InsRulesCalcHeight.js":6,"./modules/insRules/directive/InsRulesCheckElement.js":7,"./modules/insRules/directive/InsRulesDefinitionDirective.js":8,"./modules/insRules/directive/InsRulesEvaluationDirective.js":9,"./modules/insRules/factory/InsRulesDefinitionService.js":10,"./modules/insRules/factory/InsRulesEvaluationService.js":11,"./modules/insRules/factory/InsRulesValidationService.js":12,"./modules/insRules/templates/templates.js":13}],3:[function(require,module,exports){
angular.module('insDirectives').directive('insDropdownHandler', function($document) {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var focused = false;
            var initial = false;
            var elementEvents = attrs.useFocus === 'true' || attrs.useFocus === undefined ? 'click focus' : 'click';
            var onClick = function (event) {
                var isChild = element.has(event.target).length > 0;
                var isSelf = element[0] == event.target;
                var isInside = isChild || isSelf;
                var className = event.target.className;
                if (event.target.parentElement) {
                    className = className + ' ' + event.target.parentElement.className;
                }
                if (initial) {
                    initial = false;
                    return;
                }
                if (event.target.nodeName === 'path') {
                    className = event.target.parentElement.parentElement.className;
                } else if (event.target.nodeName === 'svg') {
                    className = event.target.parentElement.className;
                }
                if ((!isInside && className.indexOf(attrs.restrictElement) < 0) || (isInside && className.indexOf(attrs.restrictElement) < 0 && !attrs.hasOwnProperty('ngClick'))) {
                    scope.$apply(attrs.insDropdownHandler);
                    $document.off('click', onClick);
                    focused = false;
                }
            };
            element.on(elementEvents, function(event) {
                if (!focused) {
                    scope.$apply(attrs.insDropdownHandler);
                    $document.on('click', onClick);
                    focused = true;
                    initial = true;
                }
            });
        }
    };
});

},{}],4:[function(require,module,exports){
angular.module('insDirectives').directive('insInclude', function() {
    'use strict';
    // This directive will act like ng-include,
    // but not create a new scope for the template
    // Use: <div ins-include="my-template-name-here"></div>
    return {
        restrict: 'A',
        templateUrl: function(element, attrs) {
            return attrs.insInclude;
        }
    };
});

},{}],5:[function(require,module,exports){
angular.module('insRules').directive('insRulesAttributes', ['$timeout', 'InsRulesEvaluationService', '$rootScope', function($timeout, InsRulesEvaluationService, $rootScope) {
    'use strict';
    return {
        restrict: 'E',
        scope: {
            productData: '=',
            updateMethod: '&?',
            hideHeader: '&?',
            oneProduct: '=?',
            hideControls: '&?',
            subgroups: '=?',
            tempUrl: '=?', 
            readonly: '=?'
        },
        link: function($scope, $element, $attrs) {
            console.log('temp', $scope.tempUrl);

            //Fire Event for Large Group
            /*
            * @param {Object} product
            * @param {Object} attribute
            */
            $scope.updateQLI = function(product, attribute) {
                const data = {
                    product: product,
                    attribute: attribute
                };
                console.log('fire-onsave-event', data);
                $rootScope.$broadcast('fire-onsave-event', data);
            };

            //if subgroup list passed to directive - parse all attribute categories and make a map
            $scope.setSubGroups = function() {
                const product = $scope.productData[0];
                if (!$scope.subgroupMap) {
                    $scope.subgroupMap = {};
                    for (let i = 0; i < $scope.subgroups.length; i++) {
                        $scope.subgroupMap[$scope.subgroups[i]] = {};
                    }
                    $scope.switchMap = {};
                }
                console.log($scope.subgroups);
                for (let i = 0; i < product.attributeCategories.records.length; i++) {
                    const category = product.attributeCategories.records[i];
                    $scope.switchMap[category.id] = {};
                    for (let j = 0; j < category.productAttributes.records.length; j++) {
                        const attr = category.productAttributes.records[j];
                        let key = attr.attributeGroupType || 'Other';
                        if (attr.code.indexOf('_covered') > -1) {
                            $scope.switchMap[category.id][key] = attr;
                        } else {
                            if (!$scope.subgroupMap[key]) {
                                key = 'Other'; // key not in subgroup list, put in other column
                            }
                            if (!$scope.subgroupMap[key][category.id]) {
                                $scope.subgroupMap[key][category.id] = [];
                            }
                            $scope.subgroupMap[key][category.id].push(attr);
                        }
                    }
                }
                //Make sure labels have pairs ['In-Network' - 'Out-Of-Network'] or tripletes ['In-Network-2' - 'In-Network' - 'Out-Of-Network']
                for (let i = 0; i < product.attributeCategories.records.length; i++) {
                    const categoryId = product.attributeCategories.records[i].id;
                    let inNetworkArray, outNetworkArray, inNetworkArray2;
                    if ($scope.subgroupMap['In-Network']) {
                        inNetworkArray = $scope.subgroupMap['In-Network'][categoryId];
                    }
                    if ($scope.subgroupMap['Out-Of-Network']) {
                        outNetworkArray = $scope.subgroupMap['Out-Of-Network'][categoryId];
                    }
                    if ($scope.subgroupMap['In-Network-2']) {
                        inNetworkArray2 = $scope.subgroupMap['In-Network-2'][categoryId];
                    }
                    $scope.syncAttributeArrays(inNetworkArray, outNetworkArray, true); //make sure there is a corresponding attr in out of network array with same label
                    $scope.syncAttributeArrays(outNetworkArray, inNetworkArray, false); //do the same for in network array
                    //if Preferred Network do the same:
                    if (inNetworkArray2) {
                        $scope.syncAttributeArrays(inNetworkArray2, inNetworkArray, true);
                        $scope.syncAttributeArrays(inNetworkArray2, outNetworkArray, true);
                        $scope.syncAttributeArrays(inNetworkArray, inNetworkArray2, false); //don't need ot do for outofnetwork since they are already the same
                    }
                }
                console.log($scope.switchMap); //Map for switches
                console.log($scope.subgroupMap); //Map for subgroup columns
            };

            //Function to ensure all network columns have the same amount of rows
            /*
            * @param {Array} list1
            * @param {Array} list2
            * @param {Boolean} hideLabel flag -  to hide label for attr  - require outNetwork to be last col
            */
            $scope.syncAttributeArrays = function(list1, list2, hideLabel) { //pass in hidelabel as parameter - if putting attribute into out of network makesure label is hidden
                if (list1) {
                    for (let j = 0; j < list1.length; j++) { //check to make sure for attr for list 1 has a label in list 2
                        let label = list1[j].label;
                        let labelPairing = false;
                        if (list2) {
                            for (let k = 0; k < list2.length; k++) {
                                if (list2[k].label === label) {
                                    labelPairing = true; //set to true if a match
                                }
                                list2[k].hideLabel = hideLabel;
                            }
                        }
                        if (!labelPairing && list2) {
                            list2.push(
                                {label: label,
                                    hideLabel: hideLabel,
                                    visibility: 'hidden',
                                    description: 'this is a dummy attribute to provide a pairing for an attribute - UI only, do not save'
                                }
                            );
                        }
                    }
                }
            };

            //On load: if subgorups, init subgroup maps
            if ($scope.subgroups) {
                $scope.setSubGroups();
            }

            $rootScope.$on('vloc-ins-expand-all', function(e, data) {
                for(let i = 0; i < data.length; i++){
                    if(data[i].attributeCategories && (data[i].productId === $scope.categoryAccordion.productId)) {
                        $scope.categoryAccordion.expandAll(data[i].attributeCategories.records);
                    }
                }
            });

            $rootScope.$on('vloc-ins-collapse-all', function(e, data) {
                for(let i = 0; i < data.length; i++){
                    if(data[i].attributeCategories && (data[i].productId === $scope.categoryAccordion.productId)) {
                        $scope.categoryAccordion.collapseAll(data[i].attributeCategories.records);
                    }
                }
            });


            $scope.categoryAccordion = {
                activePanels: [],
                expandAll: function(categories) {
                    var self = this;
                    angular.forEach(categories, function(category, i) {
                        if (i === 0) {
                            self.activePanels = [];
                        }
                        self.activePanels.push(i);
                        $scope.decideOverflowClass(category, i);
                    });
                },
                collapseAll: function(categories) {
                    this.activePanels = [];
                    angular.forEach(categories, function(category, i) {
                        $scope.decideOverflowClass(category, i);
                    });
                }
            };

            //expandAllOnLoad called in ng-init in 'ins-rule-attributes-template-subgroups'
            //sets all accordions to expand on load
            $scope.expandAllOnLoad = function(records){
                $timeout(function() {
                    $scope.categoryAccordion.expandAll(records);
                }, 400);
            }

            $scope.decideOverflowClass = function(category, index) {
                if ($scope.categoryAccordion.activePanels.indexOf(index) > -1) {
                    $timeout(function() {
                        category.overflowUnset = true;
                    }, 400);
                } else {
                    category.overflowUnset = false;
                }
            };

            $scope.toggleOverflow = function(event) {
                var toggleEl = $(event.currentTarget).next();
                if (toggleEl.hasClass('overflow-unset')) {
                    toggleEl.removeClass('overflow-unset');
                } else {
                    $timeout(function() {
                        toggleEl.addClass('overflow-unset');
                    }, 400);
                }
            };

            // Only for multiselect dropdowns
            $scope.countSelected = function(attribute) {
                if (attribute.userValues && attribute.userValues.constructor === Array) {
                    attribute.multiSelectCount = attribute.userValues.length;
                } else {
                    attribute.userValues = [];
                    attribute.multiSelectCount = 0;
                }
            };

            // Only for multiselect dropdowns
            $scope.toggleValue = function(attribute, value, ruleSetValue) {
                if (ruleSetValue) {
                    return;
                }
                if (attribute.userValues && attribute.userValues.constructor === Array && attribute.userValues[0] && attribute.userValues[0].constructor === Object) {
                    //multipicklist checkbox -- value toggled on ng-model
                } else {
                    if (attribute.userValues.indexOf(value.value) > -1) {
                        attribute.userValues.splice(attribute.userValues.indexOf(value.value), 1);
                    } else {
                        attribute.userValues.push(value.value);
                    }
                    $scope.countSelected(attribute);
                }
            };

            $scope.$watch('productData', function(newValue, oldValue) {
                if (newValue) {
                    console.log('$scope.productData', $scope.productData);
                    InsRulesEvaluationService.doProductLoop($scope.productData, true, false, false , InsRulesEvaluationService.cleanAttributeData).then(function(response) {
                        $scope.processedProductData = response;
                        console.log('$scope.processedProductData', $scope.processedProductData);
                    });
                }
            });
        },
        templateUrl: function(elem, attrs) {
           return attrs.tempUrl || 'ins-rules-attributes-template.tpl.html';
       }
    };
}]);

},{}],6:[function(require,module,exports){
angular.module('insRules').directive('insRulesCalcHeight', ['$timeout', function($timeout) {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var watchElementsClassNames = [
                '.slds-checkbox',
                '.slds-radio',
                '.via-ins-attributes-attribute-messages-message'
            ];
            scope.$watch(
                // This function is returns the value that is watched in the next function.
                // Collecting the length of child elements that would affect the height of this container.
                function() { 
                    var watchElementsLength = 0;
                    watchElementsLength = watchElementsLength + element[0].children.length;
                    angular.forEach(watchElementsClassNames, function(watchElementsClassName) {
                        if ($(element[0]).find(watchElementsClassName) && $(element[0]).find(watchElementsClassName).length) {
                            watchElementsLength = watchElementsLength + $(element[0]).find(watchElementsClassName).length;
                        }
                    });
                    return watchElementsLength;
                },
                function(newValue, oldValue) {
                    var containerHeight = 4;
                    if (newValue !== oldValue || !attrs.style) {
                        $timeout(function() {
                            angular.forEach(element[0].children, function(child) {
                                containerHeight += $(child).outerHeight(true);
                            });
                            containerHeight = containerHeight + 'px';
                            $(element[0]).css({height: containerHeight});
                        });
                    }
                }
            );
        }
    };
}]);
},{}],7:[function(require,module,exports){
angular.module('insRules').directive('insRulesCheckElement', ['$rootScope', '$timeout', function($rootScope, $timeout) {
    'use strict';
    return {
        restrict: 'A',
        scope: {
            insRulesCheckElement: '=',
            checkProduct: '=',
            ngInit: '&?'
        },
        link: function(scope, element, attrs) {
            scope.productId = scope.checkProduct.Id || scope.checkProduct.productId || scope.checkProduct['Product2.Id'].value;
            if (!$rootScope.checkElementLastProductId || ($rootScope.checkElementLastProductId && $rootScope.checkElementLastProductId !== scope.productId)) {
                $rootScope.checkElementLastProductId = angular.copy(scope.productId);
                scope.insRulesCheckElement = [];
            }
            $rootScope.checkElementLastProductId = angular.copy(scope.productId);
            $timeout(function() {
                if (element[0].className.indexOf('ng-hide') < 0 && !scope.insRulesCheckElement.length) {
                    if(!scope.insRulesCheckElement.length) {
                        scope.insRulesCheckElement = [];
                    }
                    scope.insRulesCheckElement.push(parseInt(attrs.categoryIndex));
                    $(element).addClass('in');
                    if (scope.ngInit) {
                        scope.ngInit();
                    }
                }
            });
        }
    };
}]);
},{}],8:[function(require,module,exports){
angular.module('insRules').directive('insRules', ['$rootScope', '$timeout', 'InsRulesDefinitionService', 'InsRulesValidationService', function($rootScope, $timeout, InsRulesDefinitionService, InsRulesValidationService) {
    'use strict';
    // While using viaExpressionEngine from OUI, we need to convert the UI to look like SLDS instead of bootstrap until they upgrade their templates
    function resetUIToSlds(scrollToBottom) {
        $timeout(function() {
            var modalEl = $('.vloc-modal-container .vloc-modal-content');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds)').addClass('slds-box slds-theme_shade slds-m-vertical_small');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) > .col-xs-6 + .col-xs-3').addClass('slds-form-element slds-medium-size_2-of-8 slds-p-right_small slds-m-bottom_xx-small vloc-ins-rule-insert-operator');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) > .col-xs-3.slds-form-element').prepend('<label class="slds-form-element__label">Insert Operator</label>');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) select[ng-model="selectedOperator"]').addClass('slds-select vloc-operater-picker-select');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) select[ng-model="selectedOperator"]').wrap(
                '<div class="slds-form-element__control">' +
                    '<div class="slds-select_container vloc-operater-picker_container"></div>' +
                '</div>'
            );
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) > .col-xs-9').addClass('slds-form-element slds-m-bottom_xx-small');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) > .col-xs-9 > textarea').addClass('slds-textarea').attr('mentio-id', '\'tempExpression\' + $index').wrap(
                '<div class="slds-form-element__control"></div>'
            );
            $('<label class="slds-form-element__label">Condition</label>').insertBefore('.simpleExpressionBuilder:not(.already-upgraded-to-slds) .slds-textarea');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) > .col-xs-9 + .col-xs-3').addClass('slds-form-element');
            $('.simpleExpressionBuilder:not(.already-upgraded-to-slds) select[ng-model="selectedComponent"]').addClass('slds-select').wrap(
                '<div class="slds-form-element__control"></div>'
            );
            $('<label class="slds-form-element__label">Functions</label>').insertBefore('.simpleExpressionBuilder:not(.already-upgraded-to-slds) select[ng-model="selectedComponent"]');
            if (scrollToBottom && modalEl.length) {
                modalEl[0].scrollTop = modalEl[0].scrollHeight;
            }
            $('.simpleExpressionBuilder').addClass('already-upgraded-to-slds');
        });
    }

    return {
        restrict: 'E',
        scope: {
            rules: '=',
            productId: '=',
            rulesOptions: '=',
            attributeNames: '=?',
            valueRules: '@?'
        },
        templateUrl: 'ins-rules-template.tpl.html',
        link: function($scope, $element, $attrs) {
            $scope.insRulesValidationService = InsRulesValidationService;
            $scope.insRulesDefinitionService = InsRulesDefinitionService;
            if (!$scope.rules || $scope.rules.constructor !== Array) {
                $scope.rules = [];
            } else {
                angular.forEach($scope.rules, function(rule) {
                    if (rule.messageType.constructor !== Object) {
                        rule.messageType = {};
                    }
                });
            }
            if (!$scope.rulesOptions || angular.equals($scope.rulesOptions, {})) {
                $scope.rulesOptions = {
                    ruleTypes: [
                        'Hide',
                        'Message',
                        'Set Value'
                    ],
                    messageTypes: [{
                        code: 'INFO',
                        label: 'Information'
                    }, {
                        code: 'WARN',
                        label: 'Warning'
                    }, {
                        code: 'ERROR',
                        label: 'Error'
                    }, {
                        code: 'RECOMMENDATION',
                        label: 'Recommendation'
                    }]
                };
            }
            if ($scope.valueRules === 'true') {
                $scope.rulesOptions.ruleTypes = ['Hide'];
            }
            // Need to check width of the container to style responsively rather than using CSS
            // media queries because this directive may be placed in a smaller width container
            // which will not trigger width-based media queries
            $scope.containerWidth = $element.outerWidth();
            $scope.smallWidthBP = 650;
            if ($scope.containerWidth < $scope.smallWidthBP) {
                $element.addClass('small-width-container');
            }
            // OUI stores the available expressions in the vlocity window object. %Element Name% only makes
            // sense in the scope of OmniScript, so we're getting rid of that and replacing it with 
            // %ProductCode.AttributeCode%
            if (vlocity && vlocity.expressionEngine && vlocity.expressionEngine.availableExpressions && vlocity.expressionEngine.availableExpressions.indexOf('%Element Name%') > -1) {
                vlocity.expressionEngine.availableExpressions.splice(vlocity.expressionEngine.availableExpressions.indexOf('%Element Name%'), 1);
                vlocity.expressionEngine.availableExpressions.unshift('%ProductCode.AttributeCode%');
            }

            if (!$scope.attributeNames && !$rootScope.typeaheadAttributeNames) {
                $scope.insRulesDefinitionService.getTypeAheadAttributes($scope, $scope.productId).then(function(result) {
                    console.log('result', result);
                    if (result.typeAheadMaps) {
                        $scope.insRulesDefinitionService.formatTypeAheadArray(result.typeAheadMaps).then(function(result2) {
                            $rootScope.typeaheadAttributeNames = result2;
                            $scope.attributeNames = $rootScope.typeaheadAttributeNames;
                            resetUIToSlds();
                        }, function(error) {
                            console.log('There has been an error in InsRulesDefinitionService.formatTypeAheadArray', error);
                            resetUIToSlds();
                        });
                    } else {
                        resetUIToSlds();
                    }
                }, function(error) {
                    console.log('There has been an error in InsRulesDefinitionService.getTypeAheadAttributes', error);
                    resetUIToSlds();
                });
            } else if (!$scope.attributeNames && $rootScope.typeaheadAttributeNames) {
                $scope.attributeNames = $rootScope.typeaheadAttributeNames;
                resetUIToSlds();
            }

            $scope.addRule = function() {
                let isError;
                for(let i = 0; i < $scope.rules.length; i++){
                    isError = !$scope.rules[i].validation.ruleType || !$scope.rules[i].validation.messageText ||!$scope.rules[i].validation.messageType
                        || !$scope.rules[i].validation.valueExpression;

                }
                if(!isError){
                    const ruleObj = {
                        ruleType: '',
                        messageType: {},
                        expression: '',
                        messageText: '',
                        newRule: true
                    };
                    $scope.rules.push(ruleObj);
                    $timeout(function() {
                        delete $scope.rules[$scope.rules.length - 1].newRule;
                        resetUIToSlds(true);
                    }, 100);
                }
                console.log($scope.rules);
            };

            $scope.deletePrompt = function(rule) {
                if (!rule.inDelete) {
                    angular.forEach($scope.rules, function(rule) {
                        rule.inDelete = false;
                    });
                }
                rule.inDelete = !rule.inDelete;
            };

            $scope.deleteRule = function(rule, index) {
                rule.inDelete = !rule.inDelete;
                $timeout(function() {
                    rule.isDeleted = true;
                }, 250);
                $timeout(function() {
                    rule.isDeleted = false;
                    $scope.rules.splice(index, 1);
                    console.log($scope.rules);
                }, 900);
            };
        }
    };
}]);
},{}],9:[function(require,module,exports){
angular.module('insRules').directive('insRulesEvaluate', ['$rootScope', 'InsRulesEvaluationService', '$timeout', function($rootScope, InsRulesEvaluationService,  $timeout) {
    'use strict';
    return {
        restrict: 'A',
        scope: {
            evalAttribute: '=insRulesEvaluate',
            evalProduct: '=insRulesProduct',
            oneProduct: '=?',
            onlyOnLoad: '=?',
            evalCoverage: '=insRulesCoverage'
        },
        require: '?ngModel',
        link: function(scope, $element, $attrs, $ngModel) {
            scope.evalProductCode = '';
            if ($ngModel && scope.evalAttribute.inputType !== 'range') {
                $ngModel.$options.$$options.debounce = {
                    default: 500,
                    blur: 0
                };
            }
            if (!$rootScope.evalProductsArray || $rootScope.evalProductsArray.constructor !== Array) {
                $rootScope.evalProductsArray = [];
            }
            if(!$rootScope.evalProductsMap ){
                $rootScope.evalProductsMap = {};
            }
            // Get the correct scope.evalProductCode
            scope.$watch('evalProduct', function(newValue, oldValue) {
                // Check if $rootScope.attributeUserValues has this product already, if not, then add
                if (newValue && (newValue['Product2.Id'] || newValue.Id) && (newValue['Product2.ProductCode'] || newValue.ProductCode)) {
                    if (scope.evalProduct['Product2.ProductCode'] && scope.evalProduct['Product2.ProductCode'].value) {
                        scope.evalProductCode = scope.evalProduct['Product2.ProductCode'].value;
                    } else {
                        scope.evalProductCode = scope.evalProduct.ProductCode;
                    }
                    // Collecting all forms of product Identifiers. First check for instanceKey and parentInstanceKey before
                    // Ids because those will be more unique if present.
                    if (scope.evalProduct.instanceKey) {
                        scope.evalProductId = scope.evalProduct.instanceKey.replace(/\s/g, '-').toLowerCase();
                    } else if (scope.evalProduct.parentInstanceKey) {
                        scope.evalProductId = scope.evalProduct.parentInstanceKey.replace(/\s/g, '-').toLowerCase();
                    } else if (scope.evalProduct['Product2.Id'] && scope.evalProduct['Product2.Id'].value) {
                        scope.evalProductId = scope.evalProduct['Product2.Id'].value;
                    } else if (scope.evalProduct.pciId) {
                        scope.evalProductId = scope.evalProduct.pciId;
                    } else {
                        scope.evalProductId = scope.evalProduct.Id;
                    }
                    // Collect all attribute values for this product if we haven't yet
                    if (!$rootScope.attributeUserValues || scope.oneProduct) {
                        $rootScope.attributeUserValues = {};
                    }
                    if (scope.evalProduct && scope.evalProductCode && scope.evalProduct.constructor !== Array) {
                         if(scope.evalProduct.parentInstanceKey){
                            $rootScope.evalProductsMap[scope.evalProductCode + '_' + scope.evalProduct.parentInstanceKey] = scope.evalProduct;
                        } else {
                            $rootScope.evalProductsMap[scope.evalProductCode] = scope.evalProduct;
                        }
                    }
                    //Only add to queue if key is not in map (i.e. haven't seen this product before) 
                    if (!$rootScope.attributeUserValues[scope.evalProductCode + '-productId-' + scope.evalProductId]) {
                        InsRulesEvaluationService.doProductLoop([scope.evalProduct], false, true, false);
                    } 
                }
            });

            scope.$watch('evalAttribute.userValues', function(newValue, oldValue) {
                let onLoad = angular.equals(newValue, oldValue); //instead of returning value, flag that they are the same - do not trigger save event
                if (newValue !== null) {
                    let mapVal = _.values($rootScope.evalProductsMap);
                    let mapKeys = _.keys($rootScope.evalProductsMap);

                    //Set Counter for how many times productLoop is called
                    $rootScope.productLoopCount = $rootScope.productLoopCount || 0;
                    $rootScope.productLoopCount += 1;

                    InsRulesEvaluationService.doProductLoop(mapVal, true, false, true, scope.onlyOnLoad).then(function(response) {
                        //timeout on callback to ensure call after all product loops performed for all watchers
                        $timeout(function() {
                            $rootScope.productLoopCount -= 1;
                            //When all doProductLoop calls have finished, fire event for save
                            //for Coverage context, component.js listens and executes changeCoverages
                            if($rootScope.productLoopCount === 0){
                                let data = {
                                    attribute : scope.evalAttribute
                                }; 
                                data.product = scope.evalProduct || scope.evalCoverage;
                                //only send event if not in popover
                                if(!data.product || (data.product && !data.product.popoverOpen)){
                                    console.log('fire-onsave-event-call');
                                    if(!onLoad){
                                        $rootScope.$broadcast('fire-onsave-event', data);
                                    }
                                }
                            }
                        });

                    });
                }
            }, true);
        }
    };
}]);
},{}],10:[function(require,module,exports){
angular.module('insRules').factory('InsRulesDefinitionService', ['$rootScope', '$q', 'dataSourceService', function($rootScope, $q, dataSourceService) {
    'use strict';
    return {
        getTypeAheadAttributes: function(scope, productId) {
            var deferred = $q.defer();
            var datasource = {};
            datasource.type = 'ApexRemote';
            datasource.value = {
                remoteNSPrefix: $rootScope.nsPrefix,
                remoteClass: 'InsuranceProductAdminHandler',
                remoteMethod: 'getTypeAheadAttributes',
                inputMap: {
                    productId: productId
                }
            };
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    deferred.resolve(data);
                },
                function(error) {
                    console.error(error);
                    deferred.reject(error);
                });
            return deferred.promise;
        },
        formatTypeAheadArray: function(typeAheadArray) {
            var deferred = $q.defer();
            var formattedArray = [];
            if (!typeAheadArray) {
                deferred.reject('No data passed into function.');
            } else {
                angular.forEach(typeAheadArray, function(product) {
                    if (product.attributeList) {
                        angular.forEach(product.attributeList, function(attribute) {
                            formattedArray.push({label: product.productCode + '.' + attribute.attributeCode});
                        });
                    }
                });
            }
            deferred.resolve(formattedArray);
            return deferred.promise;
        },
        // when a token is selected we need to append a '%' if there isn't one.
        onSelectMentioItem: function(item, elementSelector) {
            var valueExpressionElement = $(elementSelector)[0];
            var currentSelection = valueExpressionElement.value.substring(valueExpressionElement.selectionStart, valueExpressionElement.selectionEnd);
            var needsTrailingPercentage = (currentSelection.charAt(currentSelection.length - 1) === '%' ||
                (valueExpressionElement.value.length === valueExpressionElement.selectionEnd) ||
                valueExpressionElement.value.charAt(valueExpressionElement.selectionEnd) !== '%');
            return '%' + item.label + (needsTrailingPercentage ? '%' : '');
        }
    };
}]);
},{}],11:[function(require,module,exports){
/* jshint esversion: 6 */
angular.module('insRules').factory('InsRulesEvaluationService', ['$rootScope', '$q', function($rootScope, $q) {
    'use strict';
    $rootScope.userValueMap = {};
    /**
     * Fn to return product code
     * @param  {Object}     product               A product
     */
    function getProductCode(product) {
        let currentProductCode = product.ProductCode || product.productCode;
        if (product['Product2.ProductCode'] && product['Product2.ProductCode'].value) {
            currentProductCode = product['Product2.ProductCode'].value;
        }
        return currentProductCode;
    }
    /**
     * Fn to return product id
     * @param  {Object}     product               A product
     */
    function getProductId(product) {
        let currentProductId = product.Id;
        if (product.pciId) {
            currentProductId = product.pciId;
        } else if (product['Product2.Id'] && product['Product2.Id'].value) {
            currentProductId = product['Product2.Id'].value;
        }
        return currentProductId;
    }
    /**
     * helper function for doProductLoop - only run once to set Product flags (after set cache flag to true)
     * @param {string}  currentProductCode  current product code
     * @param {string}  currentProductId    current product id 
     * @param {Object}  product             the product to which records belongs to 
     * @param {Object}  rootProductsDataKey 
     * @param {Object}  lastProduct          lastProduct
     */
    function setProductInfo(product, rootProductsDataKey, lastProduct, currentProductCode, currentProductId) {
        if (lastProduct) {
            product.parentProductName = lastProduct.Name;
            product.parentProductCode = lastProduct.ProductCode || lastProduct['Product2.ProductCode'].value;
            product.parentProductId = lastProduct.pciId || lastProduct.Id || lastProduct['Product2.Id'].value;
            rootProductsDataKey = product.parentProductCode;
        }
        if (!$rootScope.rootProductsData[rootProductsDataKey]) {
            $rootScope.rootProductsData[rootProductsDataKey] = {};
        }
        $rootScope.rootProductsData[rootProductsDataKey].parentName = product.parentProductName || null;
        $rootScope.rootProductsData[rootProductsDataKey].parentProductCode = product.parentProductCode || currentProductCode;
        $rootScope.rootProductsData[rootProductsDataKey].parentId = product.parentProductId || currentProductId;
        $rootScope.rootProductsData[rootProductsDataKey].Id = currentProductId;
        if (product.instanceKey) {
            $rootScope.rootProductsData[rootProductsDataKey].productIdentifier = product.instanceKey.replace(/\s/g, '-').toLowerCase();
            rootProductsDataKey = product.instanceKey.replace(/\s/g, '-').toLowerCase() + '__' + currentProductCode;
            if (!$rootScope.rootProductsData[rootProductsDataKey]) {
                $rootScope.rootProductsData[rootProductsDataKey] = {};
            }
            $rootScope.rootProductsData[rootProductsDataKey].productIdentifier = product.instanceKey.replace(/\s/g, '-').toLowerCase();
        } else if (product.parentInstanceKey) {
            rootProductsDataKey = product.parentInstanceKey.replace(/\s/g, '-').toLowerCase() + '__' + currentProductCode;
            if (!$rootScope.rootProductsData[rootProductsDataKey]) {
                $rootScope.rootProductsData[rootProductsDataKey] = {};
            }
            $rootScope.rootProductsData[rootProductsDataKey].productIdentifier = product.parentInstanceKey.replace(/\s/g, '-').toLowerCase();
        }
        product.rootProductCode = currentProductCode;
        product.rootProductId = currentProductId;
        if (!product.productName && product['Product2.Name'] && product['Product2.Name'].value) {
            product.productName = product['Product2.Name'].value;
        }
        if (!product.ProductCode && product['Product2.ProductCode'] && product['Product2.ProductCode'].value) {
            product.ProductCode = product['Product2.ProductCode'].value;
        }
        product.cached = true;
    }
    /**
     * helper function for doProductsLoop - run to evaluate every Attribute if rules, call evaluateRule
     * @param {array}   records             the list of categories containing attrs
     * @param {string}  currentProductCode  current product code
     * @param {string}  currentProductId    current product id 
     * @param {Object}  product             the product to which records belongs to 
     * @param {Boolean}  getAttributeUserValues   Collect the userValues from attributes into a $rootScope obj
     * @param {Boolean}  evaluateRules      Whether it's time to evaluate the rules
     * @param  {Boolean}   onlyOnLoad       Will only parse attribute's once since they cannot be changed (Added: INS 102)
     * @param  {Function}  customFunction   Called if passed
     * @param {array}  attributeUserValues array containing attribute user values 
     */
    function evalAttr(records, currentProductCode, currentProductId, product, getAttributeUserValues, evaluateRules, onlyOnLoad, customFunction, attributeUserValues) {
        angular.forEach(records, function(category, j) {
            if (category.productAttributes && category.productAttributes.records) {
                angular.forEach(category.productAttributes.records, function(attribute, k) {
                    attribute.parentProductCode = currentProductCode;
                    attribute.parentProductId = currentProductId;
                    if (attribute.userValues && customFunction) {
                        attribute = customFunction(attribute);
                    }
                    if (getAttributeUserValues) {
                        attributeUserValues.push(attribute);
                    }
                    let instanceKey = product.instanceKey || product.parentInstanceKey || 'root';
                    attribute.instanceKey = instanceKey; //set attribute instancekey
                    if (!$rootScope.userValueMap[instanceKey]) {
                        $rootScope.userValueMap[instanceKey] = {};
                    }
                    $rootScope.userValueMap[instanceKey][attribute.parentProductCode + '.' + attribute.code] = getUserValues(attribute);
                    if (attribute.rules && attribute.rules.length && evaluateRules) {
                        if (!attribute.hasOwnProperty('setValueRuleCount')) {
                            attribute.setValueRuleCount = 0;
                        }
                        angular.forEach(attribute.rules, function(rule) {
                            if (rule.ruleType === 'Set Value' && !rule.counted) {
                                attribute.setValueRuleCount++;
                                rule.counted = true;
                            }
                            evaluateRule(rule, attribute, product, onlyOnLoad);
                        });
                    }
                    if (attribute.values && attribute.values.length && attribute.values[0].label && attribute.values[0].value && evaluateRules) {
                        angular.forEach(attribute.values, function(value) {
                            if (value.rules) {
                                angular.forEach(value.rules, function(rule) {
                                    evaluateRule(rule, attribute, product, onlyOnLoad, value);
                                });
                            }
                        });
                    }
                });
            }
        });
        records.cached = true;
    };
    /**
     * Multi-purpose function that loops through JSONResult data
     * @param  {Array}     products               Array of products passed in
     * @param  {Boolean}   traverseChildren       Whether we should recursively traverse childProducts
     * @param  {Boolean}   getAttributeUserValues Collect the userValues from attributes into a $rootScope obj
     * @param  {Boolean}   evaluateRules          Whether it's time to evaluate the rules
     * @param  {Boolean}   onlyOnLoad             Will only parse attribute's once since they cannot be changed (Added: INS 102)
     * @param  {Function}  customFunction         Called if passed
     * @param  {Function}  callback               Called when done
     * @return {Object}                           If getAttributeUserValues, it returns those, else products
     */
    function doProductLoop(products, traverseChildren, getAttributeUserValues, evaluateRules, onlyOnLoad, customFunction, callback, lastProduct) {
        const attributeUserValues = [];
        const deferred = $q.defer();
        console.log('%cDoProductLoop:', 'color: blue');
        // backwards compatibility check after method signature change:
        if (typeof onlyOnLoad !== 'boolean') {
            customFunction = angular.copy(onlyOnLoad);
            callback = angular.copy(customFunction);
            // Set to default false (performs the same way as pre INS 102)
            onlyOnLoad = false;
        }
        if (!$rootScope.rootProductsData) {
            $rootScope.rootProductsData = {};
        }
        angular.forEach(products, function(product, i) {
            let currentProductCode = getProductCode(product);
            if(product.productCode){
                product.ProductCode = currentProductCode;
            }
            let currentProductId = getProductId(product);
            if (!product.cached) {
                let rootProductsDataKey = product.parentProductCode ? product.parentProductCode + '__' + currentProductCode : currentProductCode + '__' + currentProductCode;
                //Set Product Info
                setProductInfo(product, rootProductsDataKey, lastProduct, currentProductCode, currentProductId, onlyOnLoad);
            }
            if (product.attributeCategories && product.attributeCategories.records) {
                evalAttr(product.attributeCategories.records, currentProductCode, currentProductId,
                    product, getAttributeUserValues, evaluateRules, onlyOnLoad, customFunction, attributeUserValues);
            }
            if (product.childProducts && product.childProducts.records && traverseChildren) {
                doProductLoop(product.childProducts.records, traverseChildren, getAttributeUserValues, evaluateRules, onlyOnLoad, customFunction, null, product);
            }
        });
        if (callback) {
            callback();
        }
        if (getAttributeUserValues) {
            angular.forEach(products, function(product, i) {
                const currentProductCode = getProductCode(product);
                if (!product.parentInstanceKey && !product.instanceKey) {
                    $rootScope.attributeUserValues[currentProductCode  + '-productId-' + 'root'] = attributeUserValues;
                } else {
                    let instanceKey = product.instanceKey || product.parentInstanceKey;
                    let productId = instanceKey ? instanceKey.replace(/\s/g, '-').toLowerCase() : product.Id || product['Product2.Id'].value;
                    $rootScope.attributeUserValues[currentProductCode + '-productId-' + productId] = attributeUserValues;
                }
            });
            console.log('attributeUserValues', attributeUserValues);
            deferred.resolve(attributeUserValues);
        } else {
            deferred.resolve(products);
        }
        return deferred.promise;
    }

    function getUserValues(attribute) {
        let userValues;
        if (attribute) {
            userValues = attribute.userValues;
            if (userValues && userValues.constructor === Array) {
                userValues = [];
                angular.forEach(attribute.userValues, function(userValue) {
                    if (userValue.constructor === Object && !angular.equals(userValue, {})) {
                        angular.forEach(userValue, function(userValueObj, key) {
                            if (userValueObj) {
                                userValues.push(key);
                            }
                        });
                    } else {
                        userValues = attribute.userValues;
                        return;
                    }
                });
            }
        }
        return userValues;
    }

    function getExpressionValue(rule, attribute, productCode) {
        const deferred = $q.defer();
        let ruleExpression = rule.expression.replace(/\\"/g, '"');
        let mapNotPopulated = false;
        let evaluation;
        ruleExpression = ruleExpression.split('%'); //split rule string for evaluation
        for (let i = 0; i < ruleExpression.length; i++) { //iterate through index in array to replace dotnotation with userValue
            let key = ruleExpression[i];
            if (key.indexOf('.') > -1) { //if element uses dotnotation check if prodCode.attrCode value in rootMap
                if ($rootScope.userValueMap[attribute.instanceKey]) {
                    let expressionValue = $rootScope.userValueMap[attribute.instanceKey][key]; //set expressionValue to attribute map value
                    if (expressionValue && isNaN(expressionValue) && expressionValue.indexOf(',') > -1) {
                        expressionValue = expressionValue.split(',');
                    } else if (attribute.multiselect) {
                        expressionValue = [expressionValue];
                    }
                    expressionValue = JSON.stringify(expressionValue); //stringify just incase userValue = strValue  - it will be undefined if not "" engine parses datatypes correctly
                    if (expressionValue !== undefined && expressionValue !== '') {
                        ruleExpression[i] = expressionValue; // replace dot notation with value
                    } else {
                        mapNotPopulated = true;
                    }
                } else {
                    mapNotPopulated = true;
                }
            }
        }
        ruleExpression = ruleExpression.join(' '); //zip ruleExpression back with uservalues to send to eval fn
        if (!mapNotPopulated) { //only if expressions were replaced with userValues call evaluateExpression
            evaluation = vlocity.expressionEngine.evaluateExpression(ruleExpression);
        }
        if (typeof evaluation === 'string' && (evaluation === 'true' || evaluation === 'false')) {
            if (evaluation === 'true') {
                evaluation = true;
            } else {
                evaluation = false;
            }
        }
        deferred.resolve(evaluation);
        return deferred.promise;
    }


     /**
     * Returns an array of product code of target coverage parsed from string 
     * @param  {string}     expression           rules.expression string
     * @return {array}                           array of codes references in expression
     */
    function getExpressionProductCodes(expression) {
        const expressionProductCodes = [];
        const splitExpression = expression.split('%');
        angular.forEach(splitExpression, function(expressionPiece) {
            const expressionPieceParts = expressionPiece.split('.');
            const lengthArray = Array.apply(null, {
                length: expressionPieceParts.length
            }).map(Number.call, Number);
            let trackedExpressionProductCode = '';
            if (expressionPiece.indexOf('.') > -1) {
                if (expressionPieceParts.length > 2) {
                    // Say we have an attribute with multiple dots like Rent.SUPER.attribute.lots.of.dots,
                    // we still need to figure out the product code from this, so we'll check for 'Rent',
                    // 'Rent.SUPER', 'Rent.SUPER.attribute', and 'Rent.SUPER.attribute.of'
                    angular.forEach(lengthArray, function(part, i) {
                        if (!trackedExpressionProductCode) {
                            trackedExpressionProductCode = expressionPieceParts[i];
                        } else {
                            trackedExpressionProductCode = trackedExpressionProductCode + '.' + expressionPieceParts[i];
                        }
                        expressionProductCodes.push(trackedExpressionProductCode);
                    });
                } else {
                    expressionProductCodes.push(expressionPieceParts[0]);
                }
            }
        });
        return expressionProductCodes;
    }

    // If we find a rule that has evaluated true, we shouldn't set the attribute/value hiddenByRule to false
    // until we know all rules are false
    function checkAllHideRules(attrOrVal, rule, ruleAttribute, expressionProductCode) {
        const deferred = $q.defer();
        getExpressionValue(rule, ruleAttribute, expressionProductCode).then(function(result) {
            rule.hiddenByRule = result;
            angular.forEach(attrOrVal.rules, function(checkRule) {
                if (checkRule.ruleType === 'Hide' && checkRule.hiddenByRule) {
                    attrOrVal.foundHideRule = true;
                }
            });
            if (attrOrVal.foundHideRule) {
                attrOrVal.hiddenByRule = true;
            } else {
                attrOrVal.hiddenByRule = false;
            }
            deferred.resolve(attrOrVal);
            delete attrOrVal.foundHideRule;
        }, function(error) {
            console.error('Error in getExpressionValue', rule, ruleAttribute, expressionProductCode);
        });
        return deferred.promise;
    }
    /**
     * 
     * @param {Object} rule - the current rule
     * @param {Object} product - the product the rule's attribute is on
     */
    function getValueExpressionAttributeCodes(rule, product) {
        const valueExpressionAttributes = {};
        // Attributes will only exist if bracketed by % symbols
        if (rule.valueExpression && rule.valueExpression.indexOf('%') > -1) {
            const valueExpressionAtrrDotProds = rule.valueExpression.split('%');
            for (let i = valueExpressionAtrrDotProds.length - 1; i >= 0; i--) {
                // We want to remove the element from the array if it does not contain a period, or if it does contain parentheses
                if (valueExpressionAtrrDotProds[i].indexOf('.') < 0 || valueExpressionAtrrDotProds[i].search(/[\(\)]/g) > -1) {
                    valueExpressionAtrrDotProds.splice(i, 1);
                }
            }
            if (valueExpressionAtrrDotProds.length) {
                let valueExpressionProductCodes = [];
                for (let i = 0; i < valueExpressionAtrrDotProds.length; i++) {
                    const split = valueExpressionAtrrDotProds[i].split('.');
                    // We get the possible product codes by iterating backwards and joining the array that is left. After the join,
                    // we pop off the first element and join the remaining on the next loop, and so on
                    for (let j = split.length - 1; j >= 0; j--) {
                        valueExpressionProductCodes.push(split.join('.'));
                        split.pop();
                    }
                }
                // remove duplicates
                valueExpressionProductCodes = _.uniq(valueExpressionProductCodes);
                for (let i = 0; i < valueExpressionProductCodes.length; i++) {
                    // if the attribute is on the root product, there will be no parentProductName. The $rootScope.rootProductsData is populated in
                    // doProductLoop. It basically allows us to find the right data when value expressions contain references to other product's attributes
                    let productData = $rootScope.rootProductsData[(product.parentProductCode || product.ProductCode || product['Product2.ProductCode'].value) + '__' + valueExpressionProductCodes[i]];
                    if (!productData) {
                        // We'll get in here if there's no match above. it's okay if there's no match here either, it just means the expression product code
                        // we're testing isn't right yet
                        productData = $rootScope.rootProductsData[(product.parentProductCode || product.ProductCode || product['Product2.ProductCode'].value) + '__' + (product.parentProductCode || product.ProductCode || product['Product2.ProductCode'].value)];
                    }
                    const productId = productData ? productData.Id : false;
                    if (productId) {
                        // Now we know we've got the right product and product Id in order to find the attribute data we need to fully have parsed the
                        // %ProductCode.AttributeCode% aliases in the expression
                        let currentProd = $rootScope.attributeUserValues[valueExpressionProductCodes[i] + '-productId-' + productId] || $rootScope.attributeUserValues[valueExpressionProductCodes[i] + '-productId-' + 'root'];
                        if (currentProd) {
                            for (let j = 0; j < currentProd.length; j++) {
                                const valueExpressionAttribute = currentProd[j];
                                if (rule.valueExpression.indexOf(valueExpressionAttribute.code) > -1) {
                                    valueExpressionAttributes[valueExpressionProductCodes[i] + '.' + valueExpressionAttribute.code] = valueExpressionAttribute;
                                }
                            }
                        }
                    }
                }
            }
        }
        return valueExpressionAttributes;
    }

    /**
     * Fire rule event when set value or message is invokes - this is for OS 
     */
    function fireRuleEvent(eventName, attribute, product) {
        console.log('fireRuleEvent');
        const evt = new CustomEvent(eventName, {
            detail: {
                attribute: attribute,
                product: product,
                ProductCode: product.ProductCode
            }
        });
        document.dispatchEvent(evt);
    }

    function setRuleValue(rule, attribute, valueExpressionAttributes) {
        const deferred = $q.defer();
        let valueExpression, attributeUserValues, expressionValue;
        if (rule.ruleEvaluation) {
            deferred.notify('Already parsed this rule.');
            return deferred.promise;
        }
        if (!attribute.ruleSetValue || !rule.calculatedValueExpression) {
            valueExpression = vlocity.expressionEngine.evaluateExpression(rule.valueExpression.replace(/\\"/g, '"'), function(attributeToken) {
                attributeUserValues = getUserValues(valueExpressionAttributes[attributeToken]);
                expressionValue = attributeUserValues;
                expressionValue = isNaN(expressionValue) ? expressionValue : parseFloat(expressionValue);
                if (expressionValue && isNaN(expressionValue) && expressionValue.indexOf(',') > -1) {
                    expressionValue = expressionValue.split(',');
                }
                return expressionValue;
            }, true);
            rule.calculatedValueExpression = valueExpression;
        } else if (rule.calculatedValueExpression) {
            valueExpression = rule.calculatedValueExpression;
        } else if (!attribute.ruleSetValue) {
            valueExpression = rule.valueExpression;
        } else {
            valueExpression = attribute.userValues;
        }
        let parsedValueExpression = isNaN(valueExpression) ? valueExpression : parseFloat(valueExpression);
        let valueExpressionType = typeof valueExpression;
        const attributeValuesMap = [];
        let matchedValueStr = false;
        let closestMatch, indexToChange;
        if (typeof attribute.userValues !== typeof parsedValueExpression) {
            if (typeof attribute.userValues === 'number') {
                valueExpression = parseFloat(valueExpression);
            } else if (typeof attribute.userValues === 'string') {
                if(valueExpression !== null && valueExpression !== undefined){
                    valueExpression = valueExpression.toString();
                }
            } else if (valueExpression !== null && valueExpression !== undefined && typeof attribute.userValues === 'boolean') {
                if (valueExpression.toString().toLowerCase() === 'true' || valueExpression.toString().toLowerCase() === 'false') {
                    valueExpression = (valueExpression.toString().toLowerCase() === 'true');
                } else {
                    console.error('Attribute Rules: Cannot set non-boolean value on boolean dataType. Your ' +
                        '"Set Value" value needs to be true or false on a checkbox boolean attribute.', attribute);
                }
            }
            parsedValueExpression = isNaN(valueExpression) ? valueExpression : parseFloat(valueExpression);
        }
        valueExpressionType = typeof parsedValueExpression;
        if (attribute.values[0].value) {
            angular.forEach(attribute.values, function(attrValue) {
                const parsedValue = isNaN(attrValue.value) ? attrValue.value : parseFloat(attrValue.value);
                const parsedValueType = typeof parsedValue;
                if (valueExpressionType === parsedValueType) {
                    if (valueExpressionType === 'string') {
                        if (parsedValue === parsedValueExpression) {
                            matchedValueStr = true;
                        }
                    } else if (valueExpressionType === 'number') {
                        attributeValuesMap.push({
                            value: attrValue,
                            valueExpression: valueExpression,
                            difference: parsedValue - parsedValueExpression
                        });
                    }
                }
            });
            if (!attributeValuesMap.length && !matchedValueStr) {
                valueExpression = attribute.userValues;
            } else if (attributeValuesMap.length) {
                angular.forEach(attributeValuesMap, function(attributeValuesMapValue) {
                    if (attributeValuesMapValue.difference >= 0) {
                        if (!closestMatch) {
                            closestMatch = attributeValuesMapValue;
                        }
                        if (closestMatch.difference > attributeValuesMapValue.difference) {
                            closestMatch = attributeValuesMapValue;
                        }
                    }
                });
                if (closestMatch && typeof attribute.userValues === 'object') {
                    if (typeof attribute.userValues[0] === 'object') {
                        indexToChange = 0;
                        angular.forEach(attribute.userValues, function(userValue, idx) {
                            angular.forEach(userValue, function(active, value) {
                                if (value === closestMatch.value.value) {
                                    indexToChange = idx;
                                }
                            });
                        });
                        attribute.userValues[indexToChange] = {};
                        attribute.userValues[indexToChange][closestMatch.value.value] = true;
                        attribute.ruleSetValueIndex = indexToChange;
                    } else {
                        if (attribute.userValues.indexOf(closestMatch.value.value.toString()) < 0) {
                            attribute.userValues.push(closestMatch.value.value.toString());
                            attribute.ruleSetValueIndex = attribute.userValues.indexOf(closestMatch.value.value.toString());
                        }
                        if (attribute.multiSelectCount) {
                            attribute.multiSelectCount = attribute.userValues.length;
                        }
                    }
                    valueExpression = attribute.userValues;
                    closestMatch.value.ruleSetValue = true;
                } else if (closestMatch) {
                    valueExpression = closestMatch.value.value;
                } else {
                    deferred.reject('Attribute Rules: The "Set Value" value entered is greater than any of the options for ' +
                        'this attribute, so a value cannot be set. Please use a value that is less than ' +
                        'or equal to the largest value in the attribute values.', attribute);
                    valueExpression = attribute.userValues;
                }
            }
        }
        if (attribute.inputType === 'number' || attribute.inputType === 'range') {
            valueExpression = parseFloat(valueExpression);
        }
        deferred.resolve(valueExpression);
        return deferred.promise;
    }
    /**
     * 
     * @param {Object} attribute: Attribute with more than 1 rule after a Set Value evaluated true
     * @param {Object} trueRule: The Set Value rule that evaluated true
     */
    function setOtherSetValueRulesFalse(attribute, trueRule) {
        for (let i = 0; i < attribute.rules.length; i++) {
            const rule = attribute.rules[i];
            if (rule.ruleType === 'Set Value' && rule.expression !== trueRule.expression) {
                rule.ruleEvaluation = false;
            }
        }
    }
    /**
     * Evaluated the rule against its expression's attribute value
     * @param  {Object} rule      Specific rule we are evaluating
     * @param  {Object} attribute Attribute where the rule is stored
     * @param  {Object} product   Root product of the attribute (could be a childProduct)
     * @param  {Object} value     (Optional) The value will be where the rule comes from if we have value
     */
    function evaluateRule(rule, attribute, product, onlyOnLoad, value) {
        let expressionProductCodes = [];
        let valueExpressionAttributes = {};
        let instanceKey = product.instanceKey || product.parentInstanceKey;
        let productId = instanceKey ? instanceKey.replace(/\s/g, '-').toLowerCase() : product.Id || product.productId || product['Product2.Id'].value;
        // Need to save the original userValues value on Set Value rules in order to revert:
        if (rule.ruleType === 'Set Value' && !attribute.ruleSetValue) {
            attribute.originalUserValues = angular.copy(attribute.userValues);
            attribute.originalMultiSelectCount = angular.copy(attribute.multiSelectCount);
        }
        // If the rule expression is blank, the rule evaluates to true automatically:
        if (!rule.expression || rule.expression === '') {
            if (rule.ruleType === 'Hide') {
                rule.hiddenByRule = true;
                if (value) {
                    value.hiddenByRule = true;
                    fireRuleEvent('vloc-ins-attribute-rule-hide-value', attribute, product);
                } else {
                    attribute.hiddenByRule = true;
                    fireRuleEvent('vloc-ins-attribute-rule-hide', attribute, product);
                }
            } else if (rule.ruleType === 'Message' || rule.ruleType === 'Set Value') {
                if (rule.ruleType === 'Message') {
                    rule.ruleEvaluation = true;
                    if (rule.messages && rule.messages[0] && rule.messages[0].severity === 'ERROR') {
                        attribute.errorMessage = true;
                        product.errorMessage = true;
                    }
                }
                if (rule.ruleType === 'Set Value' && (!onlyOnLoad || (onlyOnLoad && !rule.hasOwnProperty('ruleEvaluation')))) {
                    valueExpressionAttributes = getValueExpressionAttributeCodes(rule, product);
                    console.log('valueExpressionAttributes', valueExpressionAttributes);
                    setRuleValue(rule, attribute, valueExpressionAttributes).then(function(setRuleValueResult) {
                        attribute.userValues = setRuleValueResult;
                        // These are set to true because we're dealing with no expression to evaluate which is automatically true
                        rule.ruleEvaluation = true;
                        attribute.ruleSetValue = true;
                        if (attribute.rules.length > 1) {
                            setOtherSetValueRulesFalse(attribute, rule);
                        }
                        fireRuleEvent('vloc-ins-attribute-rule-set-value', attribute, product);
                    }, function(error) {
                        console.error(error);
                    }, function(notify) {
                        console.warn(notify);
                    });
                }
            }
            // If a rule expression exists, we need to evaluate it:
        } else if (rule.expression) {
            expressionProductCodes = getExpressionProductCodes(rule.expression);
            if (expressionProductCodes.length) {
                angular.forEach(expressionProductCodes, function(expressionProductCode) {
                    // $rootScope.rootProductsData keys should follow 'parentProductCode__childProductCode' convention
                    let rootProductsDataKey = (product.parentProductCode || product.ProductCode || product['Product2.ProductCode'].value) + '__' + expressionProductCode;
                    if (product.parentInstanceKey && $rootScope.rootProductsData[product.parentInstanceKey.replace(/\s/g, '-').toLowerCase() + '__' + expressionProductCode]) {
                        rootProductsDataKey = product.parentInstanceKey.replace(/\s/g, '-').toLowerCase() + '__' + expressionProductCode;
                        productId = $rootScope.rootProductsData[rootProductsDataKey].productIdentifier || $rootScope.rootProductsData[rootProductsDataKey].Id;
                    } else if ($rootScope.rootProductsData[rootProductsDataKey]) {
                        productId = $rootScope.rootProductsData[rootProductsDataKey].productIdentifier || $rootScope.rootProductsData[rootProductsDataKey].Id;
                    }
                    if (!product.parentInstanceKey || $rootScope.attributeUserValues[expressionProductCode + '-productId-root']){
                        productId = 'root';
                    }
                    if ($rootScope.attributeUserValues[expressionProductCode + '-productId-' + productId]) {
                        angular.forEach($rootScope.attributeUserValues[expressionProductCode + '-productId-' + productId], function(ruleAttribute) {
                            let attributeUserValues = getUserValues(ruleAttribute);
                            if (rule.expression.indexOf(ruleAttribute.code) > -1) {
                                if (attributeUserValues && !isNaN(attributeUserValues) && attributeUserValues.constructor !== Boolean) {
                                    attributeUserValues = parseFloat(attributeUserValues);
                                }
                                if (rule.ruleType === 'Hide') {
                                    if (value) {
                                        checkAllHideRules(value, rule, ruleAttribute, expressionProductCode).then(function() {
                                            fireRuleEvent('vloc-ins-attribute-rule-hide-value', attribute, product);
                                        });
                                    } else {
                                        checkAllHideRules(attribute, rule, ruleAttribute, expressionProductCode).then(function() {
                                            fireRuleEvent('vloc-ins-attribute-rule-hide', attribute, product);
                                        });
                                    }
                                } else if (rule.ruleType === 'Message' || rule.ruleType === 'Set Value') {
                                    getExpressionValue(rule, ruleAttribute, expressionProductCode).then(function(result) {
                                        if (rule.ruleType === 'Message') {
                                            rule.ruleEvaluation = result;
                                            if (rule.messages && rule.messages[0] && rule.messages[0].severity === 'ERROR' && result) {
                                                attribute.errorMessage = true;
                                                product.errorMessage = true;
                                            } else {
                                                attribute.errorMessage = false;
                                                product.errorMessage = false;
                                            }
                                        }
                                        if (rule.ruleType === 'Set Value' && (!onlyOnLoad || (onlyOnLoad && !rule.hasOwnProperty('ruleEvaluation')))) {
                                            attribute.ruleSetValue = result;
                                            if (result && !attribute.foundTrueSetValue) {
                                                valueExpressionAttributes = getValueExpressionAttributeCodes(rule, product);
                                                setRuleValue(rule, attribute, valueExpressionAttributes).then(function(setRuleValueResult) {
                                                    attribute.userValues = setRuleValueResult;
                                                    rule.ruleEvaluation = result;
                                                    attribute.ruleSetValue = result;
                                                    if (attribute.rules.length > 1) {
                                                        setOtherSetValueRulesFalse(attribute, rule);
                                                    }
                                                    fireRuleEvent('vloc-ins-attribute-rule-set-value', attribute, product);
                                                }, function(error) {
                                                    console.error(error);
                                                }, function(notify) {
                                                    console.warn(notify);
                                                });
                                            }
                                        }
                                    }, function(error) {
                                        console.error('Error in getExpressionValue', error, rule, ruleAttribute, expressionProductCode);
                                    });
                                }
                            }
                        });
                        
                    }
                });
            }
        }
    }

    function cleanAttributeData(attribute) {
        if (attribute && attribute.inputType !== 'dropdown') {
            if (attribute.inputType === 'number') {
                attribute.userValues = parseFloat(attribute.userValues);
            }
            if (attribute.inputType === 'text' && (typeof attribute.userValues) !== 'string') {
                attribute.userValues = attribute.userValues.toString();
            }
            if (attribute.dataType === 'currency') {
                attribute.userValues = parseFloat(attribute.userValues);
            }
        }
        return attribute;
    }
    return {
        doProductLoop: doProductLoop,
        cleanAttributeData: cleanAttributeData,
        evaluateRule: evaluateRule
    };
}]);
},{}],12:[function(require,module,exports){
angular.module('insRules').factory('InsRulesValidationService', ['$rootScope', function($rootScope) {
    'use strict';
    return {
        validateRule: function(rule) {
            rule.validation = {
                ruleType: true,
                messageType: true,
                expression: true,
                messageText: true,
                valueExpression: true
            };
            if (!rule.ruleType) {
                rule.validation.ruleType = false;
            }
            if (rule.ruleType === 'Message') {
                if (!rule.messageType) {
                    rule.validation.messageType = false;
                }
                if (!rule.messageText) {
                    rule.validation.messageText = false;
                }
            }
            if (rule.ruleType === 'Set Value') {
                if (!rule.valueExpression) {
                    rule.validation.valueExpression = false;
                }
            }
            if (rule.ruleType === 'Approval') {
                if (!rule.messageText) {
                    rule.validation.messageText = false;
                }
            }
            if (!rule.expression) {
                rule.validation.expression = false;
            }
            return rule;
        }
    };
}]);
},{}],13:[function(require,module,exports){
angular.module("insRules").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ins-rules-attributes-template-subgroups.tpl.html",'<ul class="via-ins-attributes-products-container">\n    <li class="via-ins-attributes-product" ng-repeat="product in processedProductData" ins-rules-coverage="product" ins-rules-evaluate ins-rules-product="product" one-product="oneProduct">\n        <div class="slds-border_bottom via-right-col-header slds-p-vertical_small slds-m-bottom_small" ng-hide="hideHeader">\n            <div class="via-product-heading-container slds-grid slds-m-bottom_x-small">\n                <div class="slds-text-heading_medium via-product-name slds-truncate slds-size_7-of-8">\n                    <strong>{{product.productName}}</strong>\n                </div>\n                <div class="via-product-type slds-truncate slds-text-align_right slds-size_1-of-8" ng-if="product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'] && product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value && product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value !== null">\n                    <span>{{product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value}}</span>\n                </div>\n            </div>\n            <div class="via-product-btn-group">\n                <button class="slds-button slds-button_brand" ng-click="updateMethod()">Update</button>\n            </div>\n        </div>\n        <div class="slds-m-bottom_small via-ins-attributes-expand-collapse-categories" ng-hide="hideControls" ng-class="{\'slds-p-top_small\' : hideHeader}">\n            <a href="javascript:void(0)" ng-click="categoryAccordion.expandAll(product.attributeCategories.records)">Expand All</a>\n            <span class="slds-m-horizontal_x-small">|</span>\n            <a href="javascript:void(0)" ng-click="categoryAccordion.collapseAll(product.attributeCategories.records)">Collapse All</a>\n        </div>\n        <ul class="via-ins-attributes-categories-container" ng-model="categoryAccordion.activePanels" data-allow-multiple="true"  bs-collapse ng-init="categoryAccordion.productId = product.productId; expandAllOnLoad(product.attributeCategories.records)">\n            <li class="slds-m-bottom_xxx-small via-ins-attributes-category slds-border_top" id="via-ins-attributes-category-{{category.Code__c}}" ng-repeat="category in product.attributeCategories.records | orderBy:\'displaySequence\'" bs-collapse-target style="z-index: {{1000 - $index}}" ng-click="decideOverflowClass(category, $index)"  ins-rules-check-element="categoryAccordion.activePanels" check-product="product" category-index="{{$index}}" ng-show="(category.productAttributes.records | filter: {hidden: \'!true\', hiddenByRule: \'!true\', inputType: \'!equalizer\'}).length">\n                <div class="slds-grid slds-grid_wrap slds-size_1-of-1">\n                    <div class="slds-size_1-of-{{subgroups.length}} slds-p-top_small">\n                        <h2 class="slds-m-left_x-large slds-p-left_x-small slds-text-heading_small" bs-collapse-toggle ng-click="toggleOverflow($event)">\n                            <slds-svg-icon sprite="\'utility\'" icon="\'chevronright\'" size="\'xx-small\'" extra-classes="\'slds-m-right_xx-small\'"></slds-svg-icon>\n                            <span>{{category.Name}}</span>\n                        </h2>\n                    </div>\n                    <div class="slds-size_1-of-{{subgroups.length}} slds-p-top_xx-small slds-text-align_center" ng-repeat="subgroup in subgroups" ng-if="$index !== 0">\n                        <div class="slds-form-element vloc-switch" ng-if="switchMap[category.id][subgroup].code">\n                            <label class="slds-checkbox_toggle slds-grid">\n                            <input name="checkbox-toggle-{{$index}}" type="checkbox" aria-describedby="checkbox-toggle-{{$index}}" value="checkbox-toggle-{{$index}}" ng-model="switchMap[category.id][subgroup].userValues" ng-change="updateQLI(product, switchMap[category.id][subgroup])"/>\n                            <span id="checkbox-toggle-{{$index}}" class="slds-checkbox_faux_container" aria-live="assertive">\n                            <span class="slds-checkbox_faux"></span>\n                            <span class="slds-checkbox_on">Covered</span>\n                            <span class="slds-checkbox_off">Not Covered</span>\n                            </span>\n                            </label>\n                        </div>\n                    </div>\n                </div>\n                <ul class="via-ins-attributes-attributes-container slds-grid slds-grid_wrap" ng-class="{\'overflow-unset\': category.overflowUnset}">\n                    <div ng-repeat="subgroup in subgroups" class="slds-m-vertical_small slds-p-horizontal_xx-large" ng-class="{\'slds-size_1-of-{{subgroups.length}}\': subgroups.length, \n                        \'slds-border_right\': ($index < subgroups.length - 1) && (subgroup != \'In-Network\' && subgroup != \'In-Network-2\')}" >\n                        <li class="via-ins-attributes-cell slds-m-bottom_small via-ins-attributes-attribute slds-size_1-of-1" ng-repeat="attribute in subgroupMap[subgroup][category.id] | orderBy: \'displaySequence\' | filter: {hidden: \'!true\', hiddenByRule: \'!true\', inputType: \'!equalizer\'}" ng-class="{\'has-rules\': attribute.hasRules, \'slds-p-left_large\' : attribute.hideLabel, \'ins-out-of-network-col\' : attribute.hideLabel}" ins-rules-evaluate="attribute" ins-rules-calc-height ins-rules-coverage="product">\n                            <div ng-if="!(switchMap[category.id][subgroup].code && !switchMap[category.id][subgroup].userValues)">\n                                <div class="slds-grid via-ins-attributes-attribute-input" ng-if="attribute.inputType !== \'dropdown\' && !attribute.readonly && !attribute.multiselect && attribute.inputType !== \'radio\' && attribute.inputType !== \'range\'">\n                                    <label ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-checkbox\': attribute.inputType === \'checkbox\', \'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}" ng-if="attribute.dataType !== \'date\' && attribute.dataType !== \'datetime\'">\n                                        <div class="via-ins-attributes-attribute-currency-symbol" ng-if="attribute.dataType === \'currency\'">$</div>\n                                        <input type="{{attribute.inputType}}" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly" ng-class="{\'vloc-hidden\' : attribute.visibility === \'hidden\'}"/>\n                                        <div class="via-ins-attributes-attribute-percent-symbol" ng-if="attribute.dataType === \'percentage\'">%</div>\n                                        <label class="slds-checkbox__label" for="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" ng-if="attribute.inputType === \'checkbox\'">\n                                        <span class="slds-checkbox_faux"></span>\n                                        </label>\n                                    </div>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}" ng-if="attribute.dataType === \'date\' || attribute.dataType === \'datetime\'">\n                                        <div class="slds-is-relative via-ins-attributes-attribute-date-container" ng-if="attribute.dataType === \'date\'">\n                                            <input type="text" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-model-options="{debounce: 0}" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly" slds-date-picker />\n                                        </div>\n                                        <div class="slds-grid via-ins-attributes-attribute-datetime-container" ng-if="attribute.dataType === \'datetime\'">\n                                            <div class="slds-is-relative slds-size_1-of-2 slds-p-right_xx-small">\n                                                <input type="text" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input slds-p-horizontal_small datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-model-options="{debounce: 0}" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly" slds-date-picker />\n                                            </div>\n                                            <div class="slds-is-relative slds-size_1-of-2 slds-p-left_xx-small">\n                                                <input type="text" id="datetime-text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input slds-p-horizontal_small datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly" slds-time-picker />\n                                            </div>\n                                        </div>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-dropdown" ng-if="attribute.inputType === \'dropdown\' && !attribute.multiselect && !attribute.readonly">\n                                    <label ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="select-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                        <div class="via-ins-attributes-attribute-currency-symbol" ng-if="attribute.dataType === \'currency\'">$</div>\n                                        <div class="slds-select_container">\n                                            <select id="select-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-select datatype-{{attribute.dataType}}" ng-options="value.value as value.label for value in attribute.values | filter: {hiddenByRule: \'!true\'}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly">{{attribute.label}}</select>\n                                        </div>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-multiselect-checkbox" ng-if="attribute.multiselect && attribute.inputType === \'checkbox\'">\n                                    <legend ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label">{{attribute.label}}</legend>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                        <fieldset class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox" ng-repeat="value in attribute.values" ng-if="!value.hiddenByRule">\n                                                <input type="checkbox" id="attr-ms-cb-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}" checked="" ng-model="attribute.userValues[$index][value.value]" ng-disabled="!product.isSelected  || readonly || ($index === attribute.ruleSetValueIndex && attribute.ruleSetValue)" />\n                                                <label class="slds-checkbox__label" for="attr-ms-cb-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label">{{value.label}}</span>\n                                                </label>\n                                                </span>\n                                            </div>\n                                        </fieldset>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-multiselect-dropdown" ng-if="attribute.multiselect && attribute.inputType === \'dropdown\'">\n                                    <label ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="dropdown-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                        <div class="slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open" ng-init="attribute.dropdownOpen = false">\n                                            <button class="slds-button slds-button_neutral via-ins-attributes-attribute-dropdown-button" aria-haspopup="true" title="Show More" ng-model="attribute.userValues[$index][value.value]" id="dropdown-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" ng-model="attribute.userValues" ins-dropdown-handler="attribute.dropdownOpen = !attribute.dropdownOpen" restrict-element="via-ins-attributes-attribute-dropdown-items" ng-init="countSelected(attribute)">\n                                                <span>{{attribute.multiSelectCount}} Selected</span>\n                                                <slds-button-svg-icon sprite="\'utility\'" icon="\'down\'" extra-classes="\'slds-button__icon_right\'"></slds-button-svg-icon>\n                                                <span class="slds-assistive-text">Show More</span>\n                                            </button>\n                                            <div class="slds-dropdown slds-dropdown_left via-ins-attributes-attribute-dropdown-items" ng-show="attribute.dropdownOpen">\n                                                <ul class="slds-dropdown__list via-ins-attributes-attribute-dropdown-items-list" role="menu">\n                                                    <li class="slds-dropdown__item via-ins-attributes-attribute-dropdown-items-item" role="presentation" ng-repeat="value in attribute.values"  ng-if="!value.hiddenByRule" ng-class="{\'ins-rule-set-value\': value.ruleSetValue}">\n                                                        <a href="javascript:void(0);" class="via-ins-attributes-attribute-dropdown-items-link" role="menuitem" tabindex="0">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'check\'" size="\'x-small\'" extra-classes="\'slds-m-top_xxx-small slds-m-right_x-small\'" ng-class="{\'slds-icon_selected\': attribute.userValues.indexOf(value.value) < 0}"></slds-svg-icon>\n                                                            <span class="slds-truncate" title="Menu Item One">{{value.label}}</span>\n                                                        </a>\n                                                    </li>\n                                                </ul>\n                                            </div>\n                                        </div>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-radio-picklist" ng-if="attribute.dataType === \'text\' && attribute.inputType === \'radio\'">\n                                    <legend ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label">{{attribute.label}}</legend>\n                                    <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                        <fieldset class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-radio" ng-repeat="value in attribute.values" ng-if="!value.hiddenByRule">\n                                                <input type="radio" id="attr-radio-pl-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}" ng-checked="value.value === attribute.userValues" ng-click="attribute.userValues = value.value" />\n                                                <label class="slds-radio__label" for="attr-radio-pl-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}">\n                                                <span class="slds-radio_faux"></span>\n                                                <span class="slds-form-element__label">{{value.label}}</span>\n                                                </label>\n                                                </span>\n                                            </div>\n                                        </fieldset>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-range-slider" ng-if="attribute.inputType === \'range\'">\n                                    <label ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="range-slider-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}<span ng-if="attribute.max"> ({{attribute.min}} - {{attribute.max}})</span></label>\n                                    <div class="slds-is-relative slds-form-element slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                        <div class="slds-form-element__control via-ins-attributes-attribute-range-slider-element-control">\n                                            <div class="slds-slider">\n                                                <input type="range" id="range-slider-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" min="{{attribute.min}}" max="{{attribute.max}}" class="slds-slider__range" value="{{attribute.userValues}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue || !product.isSelected || readonly" ng-model-options="{debounce: 0}" />\n                                                <span class="slds-slider__value slds-p-right_none" aria-hidden="true">{{attribute.userValues}}<span ng-if="attribute.dataType === \'percentage\'">%</span></span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                    <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                        <div class="slds-form-element">\n                                            <div class="slds-form-element__control">\n                                                <span class="slds-checkbox">\n                                                    <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                                    <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                        <span class="slds-checkbox_faux"></span>\n                                                        <span class="slds-form-element__label slds-m-right_none">\n                                                            <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                        </span>\n                                                    </label>\n                                                </span>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-readonly" ng-if="attribute.readonly">\n                                    <label ng-hide="attribute.hideLabel" class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="text-input-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">{{attribute.label}}</label>\n                                    <div class="slds-p-left_small slds-p-right_medium slds-size_7-of-12 via-ins-attributes-attribute-uservalues">\n                                        <span class="readonly-value" ng-if="attribute.dataType === \'currency\'">{{attribute.userValues | currency}}</span>\n                                        <span class="readonly-value" ng-if="attribute.dataType !== \'currency\'">{{attribute.userValues}}</span>\n                                    </div>\n                                </div>\n                                <ul class="via-ins-attributes-attribute-messages-container" ng-if="attribute.rules.length">\n                                    <li class="slds-m-top_x-small via-ins-attributes-attribute-messages-message via-ins-attributes-attribute-messages-message-{{rule.messages[0].severity.toLowerCase()}}" ng-repeat="rule in attribute.rules" ng-if="rule.ruleType === \'Message\' && rule.ruleEvaluation" ng-class="{\'\': rule.messages[0].severity}">{{rule.messages[0].message}}</li>\n                                </ul>\n                                <div class="via-ins-attributes-attribute-messages-container" ng-if="attribute.values.length && value.rules" ng-repeat="value in attribute.values">\n                                    <ul>\n                                        <li class="slds-m-top_x-small via-ins-attributes-attribute-messages-message via-ins-attributes-attribute-messages-message-{{rule.messages[0].severity.toLowerCase()}}" ng-repeat="rule in value.rules" ng-if="rule.ruleType === \'Message\' && rule.ruleEvaluation" ng-class="{\'\': rule.messages[0].severity}">{{rule.messages[0].message}}</li>\n                                    </ul>\n                                </div>\n                            </div>\n                        </li>\n                    </div>\n                </ul>\n            </li>\n        </ul>\n    </li>\n</ul>\n<style type="text/css">\n    .via-slds ins-rules-attributes {\n    width: 100%;\n    display: block;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-product .via-right-col-header .via-product-heading-container .via-product-type {\n    line-height: 1.625rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .slds-icon {\n    fill: #16325c;\n    position: relative;\n    top: -1px;\n    transition: transform 250ms ease-in;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category h2 {\n    width: auto;\n    display: inline-block;\n    cursor: pointer;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category {\n    min-height: 2.6rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container {\n    overflow: hidden;\n    transition: height 350ms cubic-bezier(0.65, 0.05, 0.36, 1);\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category:not(.in) .via-ins-attributes-attributes-container {\n    height: 0 !important;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container.overflow-unset {\n    overflow: unset;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown {\n    width: auto;\n    min-width: 100%;\n    font-size: 0.8125rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item {\n    user-select: none;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value {\n    background-color: #ecebea;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a {\n    background-color: #ecebea;\n    cursor: not-allowed;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a:hover {\n    background-color: #ecebea;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a .slds-icon {\n    fill: #ffffff;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attributes-label {\n    word-wrap: break-word;\n    line-height: 1.3;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .readonly-value {\n    line-height: 2rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-range-slider-element-control {\n    position: absolute;\n    top: 50%;\n    transform: translateY(-50%);\n    width: calc(100% - 0.5rem);\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-currency-symbol {\n    display: inline-block;\n    height: 2rem;\n    line-height: 1.875rem;\n    font-size: 0.9375rem;\n    text-align: center;\n    background-color: #f4f6f9;\n    width: 15%;\n    float: left;\n    border: 1px solid #d8dde6;\n    border-right: none;\n    border-top-left-radius: 0.25rem;\n    border-bottom-left-radius: 0.25rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-percent-symbol {\n    display: inline-block;\n    height: 2rem;\n    line-height: 1.875rem;\n    font-size: 0.9375rem;\n    text-align: center;\n    background-color: #f4f6f9;\n    width: 15%;\n    float: right;\n    border: 1px solid #d8dde6;\n    border-left: none;\n    border-top-right-radius: 0.25rem;\n    border-bottom-right-radius: 0.25rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-input.datatype-currency,\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-select.datatype-currency {\n    width: 85%;\n    border-top-left-radius: 0;\n    border-bottom-left-radius: 0;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-input.datatype-percentage {\n    width: 85%;\n    border-top-right-radius: 0;\n    border-bottom-right-radius: 0;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues.slds-checkbox label {\n    display: inline-block;\n    margin-top: 0.35rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attributes-override label {\n    line-height: 2rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message {\n    font-weight: 400;\n    font-size: 0.75rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message:last-child {\n    margin-bottom: 1rem;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-warn {\n    color: #ffb75d;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-error {\n    color: #c23934;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-recommendation {\n    color: #1589ee;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category.in h2 .slds-icon {\n    transform: rotate(90deg);\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category.in .via-ins-attributes-attributes-container {\n    transition: height 350ms cubic-bezier(0.65, 0.05, 0.36, 1);\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .ins-out-of-network-col{\n    position: relative;\n    left:12%;\n    }\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .vloc-hidden{\n    visibility: hidden\n    }\n</style>'),
$templateCache.put("ins-rules-attributes-template.tpl.html",'<ul class="via-ins-attributes-products-container">\n    <li class="via-ins-attributes-product" ng-repeat="product in processedProductData" ins-rules-evaluate ins-rules-product="product" one-product="oneProduct">\n        <div class="slds-border_bottom via-right-col-header slds-p-vertical_small slds-m-bottom_small" ng-hide="hideHeader">\n            <div class="via-product-heading-container slds-grid slds-m-bottom_x-small">\n                <div class="slds-text-heading_medium via-product-name slds-truncate slds-size_7-of-8">\n                    <strong>{{product.productName}}</strong>\n                </div>\n                <div class="via-product-type slds-truncate slds-text-align_right slds-size_1-of-8" ng-if="product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'] && product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value && product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value !== null">\n                    <span>{{product[\'Product2.\' + $root.nsPrefix + \'Tier__c\'].value}}</span>\n                </div>\n            </div>\n            <div class="via-product-btn-group">\n                <button class="slds-button slds-button_brand" ng-click="updateMethod()">Update</button>\n                <!-- <button class="slds-button slds-button_neutral">Request Approval</button> -->\n            </div>\n        </div>\n        <div class="slds-m-bottom_small via-ins-attributes-expand-collapse-categories" ng-class="{\'slds-p-top_small\' : hideHeader}">\n            <a href="javascript:void(0)" ng-click="categoryAccordion.expandAll(product.attributeCategories.records)">Expand All</a>\n            <span class="slds-m-horizontal_x-small">|</span>\n            <a href="javascript:void(0)" ng-click="categoryAccordion.collapseAll(product.attributeCategories.records)">Collapse All</a>\n        </div>\n         <ul class="via-ins-attributes-categories-container" ng-model="categoryAccordion.activePanels" data-allow-multiple="true" bs-collapse>\n            <li class="slds-m-bottom_xxx-small via-ins-attributes-category" id="via-ins-attributes-category-{{category.Code__c}}" ng-repeat="category in product.attributeCategories.records" bs-collapse-target style="z-index: {{1000 - $index}}" ng-click="decideOverflowClass(category, $index)" ng-init="decideOverflowClass(category, $index)" ins-rules-check-element="categoryAccordion.activePanels" check-product="product" category-index="{{$index}}" ng-show="(category.productAttributes.records | filter: {hidden: \'!true\', hiddenByRule: \'!true\', inputType: \'!equalizer\'}).length">\n                <h2 class="slds-text-heading_small" bs-collapse-toggle ng-click="toggleOverflow($event)">\n                    <slds-svg-icon sprite="\'utility\'" icon="\'chevronright\'" size="\'xx-small\'" extra-classes="\'slds-m-right_xx-small\'"></slds-svg-icon>\n                    <span>{{category.Name}}</span>\n                </h2>\n                <ul class="slds-p-top_x-small slds-p-left_large via-ins-attributes-attributes-container" ng-class="{\'overflow-unset\': category.overflowUnset}" ins-rules-calc-height>\n                    <li class="slds-m-bottom_small via-ins-attributes-attribute" ng-repeat="attribute in category.productAttributes.records | filter: {hidden: \'!true\', hiddenByRule: \'!true\', inputType: \'!equalizer\'}" ng-class="{\'has-rules\': attribute.hasRules}" ins-rules-evaluate="attribute">\n                        <div class="slds-grid via-ins-attributes-attribute-input" ng-if="attribute.inputType !== \'dropdown\' && !attribute.readonly && !attribute.multiselect && attribute.inputType !== \'radio\' && attribute.inputType !== \'range\'">\n                            <label class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-checkbox\': attribute.inputType === \'checkbox\', \'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}" ng-if="attribute.dataType !== \'date\' && attribute.dataType !== \'datetime\'">\n                                <div class="via-ins-attributes-attribute-currency-symbol" ng-if="attribute.dataType === \'currency\'">$</div>\n                                <input type="{{attribute.inputType}}" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue" />\n                                <div class="via-ins-attributes-attribute-percent-symbol" ng-if="attribute.dataType === \'percentage\'">%</div>\n                                <label class="slds-checkbox__label" for="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" ng-if="attribute.inputType === \'checkbox\'">\n                                    <span class="slds-checkbox_faux"></span>\n                                </label>\n                            </div>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}" ng-if="attribute.dataType === \'date\' || attribute.dataType === \'datetime\'">\n                                <div class="slds-is-relative via-ins-attributes-attribute-date-container" ng-if="attribute.dataType === \'date\'">\n                                    <input type="text" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-model-options="{debounce: 0}" ng-disabled="attribute.ruleSetValue" slds-date-picker />\n                                </div>\n                                <div class="slds-grid via-ins-attributes-attribute-datetime-container" ng-if="attribute.dataType === \'datetime\'">\n                                    <div class="slds-is-relative slds-size_1-of-2 slds-p-right_xx-small">\n                                        <input type="text" id="text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input slds-p-horizontal_small datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-model-options="{debounce: 0}" ng-disabled="attribute.ruleSetValue" slds-date-picker />\n                                    </div>\n                                    <div class="slds-is-relative slds-size_1-of-2 slds-p-left_xx-small">\n                                        <input type="text" id="datetime-text-input-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-input slds-p-horizontal_small datatype-{{attribute.dataType}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue" slds-time-picker />\n                                    </div>\n                                </div>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-dropdown" ng-if="attribute.inputType === \'dropdown\' && !attribute.multiselect && !attribute.readonly">\n                            <label class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="select-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                <div class="via-ins-attributes-attribute-currency-symbol" ng-if="attribute.dataType === \'currency\'">$</div>\n                                <div class="slds-select_container">\n                                    <select id="select-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" class="slds-select datatype-{{attribute.dataType}}" ng-options="value.value as value.label for value in attribute.values | filter: {hiddenByRule: \'!true\'}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue"></select>\n                                </div>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-multiselect-checkbox" ng-if="attribute.multiselect && attribute.inputType === \'checkbox\'">\n                            <legend class="slds-size_5-of-12 via-ins-attributes-attributes-label">{{attribute.label}}</legend>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                <fieldset class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox" ng-repeat="value in attribute.values" ng-if="!value.hiddenByRule">\n                                            <input type="checkbox" id="attr-ms-cb-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}" checked="" ng-model="attribute.userValues[$index][value.value]" ng-disabled="$index === attribute.ruleSetValueIndex && attribute.ruleSetValue" ng-click="toggleValue(attribute, value)" />\n                                            <label class="slds-checkbox__label" for="attr-ms-cb-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label">{{value.label}}</span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </fieldset>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-multiselect-dropdown" ng-if="attribute.multiselect && attribute.inputType === \'dropdown\'">\n                            <label class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="dropdown-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}</label>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                <div class="slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open" ng-init="attribute.dropdownOpen = false">\n                                    <button class="slds-button slds-button_neutral via-ins-attributes-attribute-dropdown-button" aria-haspopup="true" title="Show More" ng-model="attribute.userValues[$index][value.value]" id="dropdown-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" ng-model="attribute.userValues" ins-dropdown-handler="attribute.dropdownOpen = !attribute.dropdownOpen" restrict-element="via-ins-attributes-attribute-dropdown-items" ng-init="countSelected(attribute)">\n                                        <span>{{attribute.multiSelectCount}} Selected</span>\n                                        <slds-button-svg-icon sprite="\'utility\'" icon="\'down\'" extra-classes="\'slds-button__icon_right\'"></slds-button-svg-icon>\n                                        <span class="slds-assistive-text">Show More</span>\n                                    </button>\n                                    <div class="slds-dropdown slds-dropdown_left via-ins-attributes-attribute-dropdown-items" ng-show="attribute.dropdownOpen">\n                                        <ul class="slds-dropdown__list via-ins-attributes-attribute-dropdown-items-list" role="menu">\n                                            <li class="slds-dropdown__item via-ins-attributes-attribute-dropdown-items-item" role="presentation" ng-repeat="value in attribute.values" ng-click="toggleValue(attribute, value, value.ruleSetValue)" ng-if="!value.hiddenByRule" ng-class="{\'ins-rule-set-value\': value.ruleSetValue}">\n                                                <a href="javascript:void(0);" class="via-ins-attributes-attribute-dropdown-items-link" role="menuitem" tabindex="0">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'check\'" size="\'x-small\'" extra-classes="\'slds-m-top_xxx-small slds-m-right_x-small\'" ng-class="{\'slds-icon_selected\': attribute.userValues.indexOf(value.value) < 0}"></slds-svg-icon>\n                                                    <span class="slds-truncate" title="Menu Item One">{{value.label}}</span>\n                                                </a>\n                                            </li>\n                                        </ul>\n                                    </div>\n                                </div>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-radio-picklist" ng-if="attribute.dataType === \'text\' && attribute.inputType === \'radio\'">\n                            <legend class="slds-size_5-of-12 via-ins-attributes-attributes-label">{{attribute.label}}</legend>\n                            <div class="slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                <fieldset class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-radio" ng-repeat="value in attribute.values" ng-if="!value.hiddenByRule">\n                                            <input type="radio" id="attr-radio-pl-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}" ng-checked="value.value === attribute.userValues" ng-click="attribute.userValues = value.value" />\n                                            <label class="slds-radio__label" for="attr-radio-pl-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}-{{value.value}}">\n                                                <span class="slds-radio_faux"></span>\n                                                <span class="slds-form-element__label">{{value.label}}</span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </fieldset>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-range-slider" ng-if="attribute.inputType === \'range\'">\n                            <label class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="range-slider-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}">{{attribute.label}}<span ng-if="attribute.max"> ({{attribute.min}} - {{attribute.max}})</span></label>\n                            <div class="slds-is-relative slds-form-element slds-p-left_small via-ins-attributes-attribute-uservalues" ng-class="{\'slds-size_5-of-12 slds-p-right_medium\': attribute.showOverride, \'slds-size_7-of-12\': !attribute.showOverride}">\n                                <div class="slds-form-element__control via-ins-attributes-attribute-range-slider-element-control">\n                                    <div class="slds-slider">\n                                        <input type="range" id="range-slider-{{product.ProductCode}}-{{category.Code__c}}-{{attribute.attributeId}}" min="{{attribute.min}}" max="{{attribute.max}}" class="slds-slider__range" value="{{attribute.userValues}}" ng-model="attribute.userValues" ng-disabled="attribute.ruleSetValue" ng-model-options="{debounce: 0}" />\n                                        <span class="slds-slider__value slds-p-right_none" aria-hidden="true">{{attribute.userValues}}<span ng-if="attribute.dataType === \'percentage\'">%</span></span>\n                                    </div>\n                                </div>\n                            </div>\n                            <div class="slds-size_2-of-12 slds-text-align_right via-ins-attributes-attributes-override" ng-if="attribute.showOverride">\n                                <div class="slds-form-element">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.override" />\n                                            <label class="slds-checkbox__label" for="attribute-override-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                                <span class="slds-form-element__label slds-m-right_none">\n                                                    <slds-svg-icon sprite="\'utility\'" icon="\'approval\'" size="\'xx-small\'"></slds-svg-icon>\n                                                </span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class="slds-grid via-ins-attributes-attribute-readonly" ng-if="attribute.readonly">\n                            <label class="slds-size_5-of-12 via-ins-attributes-attributes-label" for="text-input-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">{{attribute.label}}</label>\n                            <div class="slds-p-left_small slds-p-right_medium slds-size_7-of-12 via-ins-attributes-attribute-uservalues">\n                                <div class="slds-form-element" ng-if="attribute.inputType === \'checkbox\' && !attribute.multiselect">\n                                    <div class="slds-form-element__control">\n                                        <span class="slds-checkbox">\n                                            <input type="checkbox" name="options" id="attribute-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}" ng-model="attribute.userValues" ng-disabled="true"/>\n                                            <label class="slds-checkbox__label" for="attribute-checkbox-{{$parent.$parent.$index}}-{{$parent.$index}}-{{$index}}">\n                                                <span class="slds-checkbox_faux"></span>\n                                            </label>\n                                        </span>\n                                    </div>\n                                </div>\n                                <span class="readonly-value" ng-if="attribute.dataType === \'currency\'">{{attribute.userValues | currency}}</span>\n                                <span class="readonly-value" ng-if="attribute.dataType !== \'currency\' &&  (attribute.inputType !== \'checkbox\' || attribute.multiselect)">{{attribute.userValues}}</span>\n                            </div>\n                        </div>\n                        <ul class="via-ins-attributes-attribute-messages-container" ng-if="attribute.rules.length">\n                            <li class="slds-m-top_x-small via-ins-attributes-attribute-messages-message via-ins-attributes-attribute-messages-message-{{rule.messages[0].severity.toLowerCase()}}" ng-repeat="rule in attribute.rules" ng-if="rule.ruleType === \'Message\' && rule.ruleEvaluation" ng-class="{\'\': rule.messages[0].severity}">{{rule.messages[0].message}}</li>\n                        </ul>\n                        <div class="via-ins-attributes-attribute-messages-container" ng-if="attribute.values.length && value.rules" ng-repeat="value in attribute.values">\n                            <ul>\n                                <li class="slds-m-top_x-small via-ins-attributes-attribute-messages-message via-ins-attributes-attribute-messages-message-{{rule.messages[0].severity.toLowerCase()}}" ng-repeat="rule in value.rules" ng-if="rule.ruleType === \'Message\' && rule.ruleEvaluation" ng-class="{\'\': rule.messages[0].severity}">{{rule.messages[0].message}}</li>\n                            </ul>\n                        </div>\n                    </li>\n                </ul>\n            </li>\n        </ul>\n    </li>\n</ul>\n<style type="text/css">\n    .via-slds ins-rules-attributes {\n        width: 100%;\n        display: block;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-product .via-right-col-header .via-product-heading-container .via-product-type {\n        line-height: 1.625rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .slds-icon {\n        fill: #16325c;\n        position: relative;\n        top: -1px;\n        transition: transform 250ms ease-in;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category h2 {\n        width: auto;\n        display: inline-block;\n        cursor: pointer;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container {\n        overflow: hidden;\n        transition: height 350ms cubic-bezier(0.65, 0.05, 0.36, 1);\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category:not(.in) .via-ins-attributes-attributes-container {\n        height: 0 !important;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container.overflow-unset {\n        overflow: unset;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown {\n        width: auto;\n        min-width: 100%;\n        font-size: 0.8125rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item {\n        user-select: none;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value {\n        background-color: #ecebea;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a {\n        background-color: #ecebea;\n        cursor: not-allowed;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a:hover {\n        background-color: #ecebea;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .slds-dropdown .via-ins-attributes-attribute-dropdown-items-item.ins-rule-set-value > a .slds-icon {\n        fill: #ffffff;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attributes-label {\n        word-wrap: break-word;\n        line-height: 1.3;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .readonly-value {\n        line-height: 2rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-range-slider-element-control {\n        position: absolute;\n        top: 50%;\n        transform: translateY(-50%);\n        width: calc(100% - 0.5rem);\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-currency-symbol {\n        display: inline-block;\n        height: 2rem;\n        line-height: 1.875rem;\n        font-size: 0.9375rem;\n        text-align: center;\n        background-color: #f4f6f9;\n        width: 15%;\n        float: left;\n        border: 1px solid #d8dde6;\n        border-right: none;\n        border-top-left-radius: 0.25rem;\n        border-bottom-left-radius: 0.25rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .via-ins-attributes-attribute-percent-symbol {\n        display: inline-block;\n        height: 2rem;\n        line-height: 1.875rem;\n        font-size: 0.9375rem;\n        text-align: center;\n        background-color: #f4f6f9;\n        width: 15%;\n        float: right;\n        border: 1px solid #d8dde6;\n        border-left: none;\n        border-top-right-radius: 0.25rem;\n        border-bottom-right-radius: 0.25rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-input.datatype-currency,\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-select.datatype-currency {\n        width: 85%;\n        border-top-left-radius: 0;\n        border-bottom-left-radius: 0;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues .slds-input.datatype-percentage {\n        width: 85%;\n        border-top-right-radius: 0;\n        border-bottom-right-radius: 0;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-uservalues.slds-checkbox label {\n        display: inline-block;\n        margin-top: 0.35rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attributes-override label {\n        line-height: 2rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message {\n        font-weight: 400;\n        font-size: 0.75rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message:last-child {\n        margin-bottom: 1rem;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-warn {\n        color: #ffb75d;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-error {\n        color: #c23934;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category .via-ins-attributes-attributes-container .via-ins-attributes-attribute .via-ins-attributes-attribute-messages-message.via-ins-attributes-attribute-messages-message-recommendation {\n        color: #1589ee;\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category.in h2 .slds-icon {\n        transform: rotate(90deg);\n    }\n\n    .via-slds .via-ins-attributes-products-container .via-ins-attributes-categories-container .via-ins-attributes-category.in .via-ins-attributes-attributes-container {\n        transition: height 350ms cubic-bezier(0.65, 0.05, 0.36, 1);\n    }\n</style>'),
$templateCache.put("ins-rules-template.tpl.html",'<div class="slds-p-top_small slds-p-bottom_x-small vloc-ins-rules-container" ng-if="rules.length">\n    <div class="slds-border_bottom vloc-ins-rule" ng-repeat="rule in rules">\n        <div class="slds-p-vertical_x-small slds-p-left_x-small slds-p-right_medium vloc-ins-rule-inner-wrapper" ng-class="{\'delete-warning-active\': rule.inDelete, \'delete-processing\': rule.isDeleted, \'adding-new-rule\': rule.newRule}" style="z-index: {{rules.length + 10 - $index}}">\n            <div class="slds-grid slds-m-bottom_xx-small vloc-ins-rule-type-wrapper">\n                <div class="slds-size_1-of-12 vloc-ins-rule-number" ng-class="{\'slds-p-right_xx-small\': containerWidth < smallWidthBP}"><span>{{$index + 1}}</span></div>\n                <div class="slds-size_11-of-12">\n                    <div class="slds-grid">\n                        <div class="slds-p-right_small vloc-ins-rule-type-container" ng-class="{\'slds-size_2-of-5\': containerWidth < smallWidthBP, \'slds-size_2-of-8\': containerWidth >= smallWidthBP}">\n                            <div class="slds-form-element vloc-ins-rule-form-element" ng-class="{\'slds-has-error\': insRulesValidationService.validateRule(rule) && !rule.validation.ruleType}">\n                                <label class="slds-form-element__label vloc-ins-rule-form-element__label" for="rule-type-select-{{$index + 1}}">Type</label>\n                                <div class="slds-form-element__control">\n                                    <div class="slds-select_container">\n                                        <select id="rule-type-select-{{$index + 1}}" class="slds-select" ng-model="rule.ruleType" ng-options="ruleType for ruleType in rulesOptions.ruleTypes"></select>\n                                    </div>\n                                </div>\n                                <div class="slds-form-element__help vloc-ins-rule-validation-msg" id="vloc-ins-rule-error-{{$index + 1}}">Type is required</div>\n                            </div>\n                        </div>\n                        <div class="slds-p-right_small vloc-ins-rule-extra-definition-container" ng-class="{\'slds-size_2-of-5\': containerWidth < smallWidthBP, \'slds-size_2-of-8\': containerWidth >= smallWidthBP && rule.ruleType === \'Hide\' || containerWidth >= smallWidthBP && rule.ruleType === \'Message\', \'slds-size_4-of-8\': containerWidth >= smallWidthBP && rule.ruleType === \'Set Value\'}">\n                            <div class="slds-form-element vloc-ins-rule-form-element" ng-class="{\'slds-has-error\': insRulesValidationService.validateRule(rule) && !rule.validation.valueExpression}" ng-if="rule.ruleType === \'Set Value\'">\n                                <div class="slds-form-element">\n                                    <label class="slds-form-element__label vloc-ins-rule-form-element__label" for="set-value-value-{{$index + 1}}">Value to set (may use attribute value)</label>\n                                    <div class="slds-form-element__control">\n                                        <input type="text" id="set-value-value-{{$index + 1}}" mentio mentio-trigger-char="\'%\'" mentio-items="attributeNames" mentio-select="insRulesDefinitionService.onSelectMentioItem(item, \'.vloc-ins-rule-value-expression-\' + $index)" mentio-template-url="expression-engine-element-name.tpl.html" mentio-id="\'valueExpression\' + $index" class="slds-input vloc-ins-rule-value-expression vloc-ins-rule-value-expression-{{$index}}" ng-model="rule.valueExpression" />\n                                    </div>\n                                </div>\n                                <div class="slds-form-element__help vloc-ins-rule-validation-msg" id="vloc-ins-rule-error-{{$index + 1}}">Value is required</div>\n                            </div>\n                            <div class="slds-form-element vloc-ins-rule-form-element" ng-class="{\'slds-has-error\': insRulesValidationService.validateRule(rule) && !rule.validation.messageType}" ng-if="rule.ruleType === \'Message\'">\n                                <label class="slds-form-element__label vloc-ins-rule-form-element__label" for="rule-type-select-{{$index + 1}}">Message Type</label>\n                                <div class="slds-form-element__control">\n                                    <div class="slds-select_container">\n                                        <select id="rule-type-select-{{$index + 1}}" class="slds-select" ng-model="rule.messageType.code" ng-options="messageType.code as messageType.label for messageType in rulesOptions.messageTypes"></select>\n                                    </div>\n                                </div>\n                                <div class="slds-form-element__help vloc-ins-rule-validation-msg" id="vloc-ins-rule-error-{{$index + 1}}">Message Type is required</div>\n                            </div>\n                        </div>\n                        <div ng-class="{\'slds-size_0-of-5\': containerWidth < smallWidthBP, \'slds-size_3-of-8\': containerWidth >= smallWidthBP && rule.ruleType === \'Hide\' || containerWidth >= smallWidthBP && rule.ruleType === \'Message\', \'slds-size_1-of-8\': containerWidth >= smallWidthBP && rule.ruleType === \'Set Value\'}"></div>\n                        <div class="slds-text-align_right slds-is-relative vloc-ins-rule-delete-rule-container" ng-class="{\'slds-size_1-of-5\': containerWidth < smallWidthBP, \'slds-size_1-of-8\': containerWidth >= smallWidthBP}">\n                            <button class="slds-button slds-button_icon" title="delete" ng-click="deletePrompt(rule)">\n                                <slds-button-svg-icon sprite="\'utility\'" icon="\'delete\'" size="\'medium\'" ng-if="!rule.inDelete"></slds-button-svg-icon>\n                                <slds-button-svg-icon sprite="\'utility\'" icon="\'close\'" size="\'medium\'" ng-if="rule.inDelete"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Delete Rule</span>\n                            </button>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div class="slds-grid vloc-ins-rule-expression-wrapper">\n                <div class="slds-size_1-of-12" ng-class="{\'slds-p-right_xx-small\': containerWidth < smallWidthBP}"></div>\n                <div class="slds-size_11-of-12 vloc-ins-rule-expression-container">\n                    <simple-expression-builder expression="rule.expression" element-names="attributeNames"></simple-expression-builder>\n                </div>\n            </div>\n            <div class="slds-grid vloc-ins-rule-message-wrapper" ng-if="rule.ruleType === \'Message\' || rule.ruleType === \'Approval\'">\n                <div class="slds-size_1-of-12" ng-class="{\'slds-p-right_xx-small\': containerWidth < smallWidthBP}"></div>\n                <div class="slds-size_11-of-12 vloc-ins-rule-message-container">\n                    <div class="slds-form-element vloc-ins-rule-form-element" ng-class="{\'slds-has-error\': insRulesValidationService.validateRule(rule) && !rule.validation.messageText}">\n                        <label class="slds-form-element__label vloc-ins-rule-form-element__label" for="rule-expression-{{$index + 1}}">Message</label>\n                        <div class="slds-form-element__control vloc-ins-rule-textarea__control">\n                            <textarea id="rule-expression-{{$index + 1}}" class="slds-textarea" placeholder="Enter message text" ng-model="rule.messageText"></textarea>\n                        </div>\n                        <div class="slds-form-element__help vloc-ins-rule-validation-msg" id="vloc-ins-rule-error-{{$index + 1}}">Message Text is required</div>\n                    </div>\n                </div>\n            </div>\n        </div>\n        <div class="vloc-ins-rule-delete-warning-wrapper" ng-class="{\'delete-warning-active\': rule.inDelete, \'delete-processing\': rule.isDeleted, \'adding-new-rule\': rule.newRule}">\n            <div class="slds-p-vertical_x-small slds-p-horizontal_medium slds-text-align_right slds-notify slds-theme_alert-texture vloc-ins-rule-delete-warning-header">\n                <h2 class="slds-text-heading_medium" id="ins-rules-delete-warning-{{$index + 1}}">Delete Rule</h2>\n            </div>\n            <div class="slds-p-around_medium slds-text-align_right vloc-ins-rule-delete-warning-content">\n                <p>Are you sure you want to delete this rule? This operation cannot be undone.</p>\n            </div>\n            <div class="slds-p-around_medium slds-text-align_right vloc-ins-rule-delete-warning-footer">\n                <button class="slds-button slds-button_neutral" ng-click="rule.inDelete = !rule.inDelete">Cancel</button>\n                <button class="slds-button slds-button_destructive" ng-click="deleteRule(rule, $index)">Yes, Delete</button>\n            </div>\n        </div>\n    </div>\n    <div class="slds-grid">\n        <div class="slds-size_1-of-12" ng-class="{\'slds-p-right_xx-small\': containerWidth < smallWidthBP}"></div>\n        <div class="slds-size_11-of-12">\n            <button class="slds-button vloc-ins-rule-add" ng-click="addRule()">Add Rule</button>\n        </div>\n    </div>\n</div>\n<div class="slds-p-around_small vloc-ins-no-rules-container" ng-if="!rules.length">\n    <p>There are no rules defined, please <a href="javascript:void(0)" ng-click="addRule()">add a rule</a>.</p>\n</div>\n<style type="text/css">\n    .via-slds ins-rules {\n        display: block;\n        overflow: hidden;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule {\n        position: relative;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper {\n        background-color: white;\n        position: relative;\n        z-index: 2;\n        left: 0;\n        max-height: 32rem;\n        transition: left 250ms ease-in, max-height 250ms ease-in 400ms, padding 0ms linear 600ms;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper:before {\n        position: absolute;\n        top: 0;\n        left: 0;\n        z-index: 10;\n        content: "";\n        display: block;\n        width: 100%;\n        height: 100%;\n        visibility: hidden;\n        background-color: transparent;\n        transition: background-color 150ms ease-in, visibility 0ms linear 150ms;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper.delete-warning-active {\n        left: -80%;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper.delete-processing {\n        max-height: 0;\n        padding-top: 0;\n        padding-bottom: 0;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper.delete-processing:before {\n        visibility: visible;\n        background-color: rgba(84, 105, 141, 0.8);\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper.adding-new-rule:before {\n        visibility: visible;\n        background-color: rgba(84, 105, 141, 0.8);\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-number span {\n        display: block;\n        font-size: 1rem;\n        width: 1.5rem;\n        height: 1.5rem;\n        line-height: 1.5rem;\n        border-radius: 50%;\n        background-color: #acb9ce;\n        text-align: center;\n        color: white;\n        margin: 1.6rem auto 0 auto;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-validation-msg {\n        display: none;\n        margin-top: 0.125rem;\n        margin-bottom: 0.25rem;\n        font-style: italic;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-textarea__control {\n        height: 3.5rem;\n        position: relative;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-textarea__control+.vloc-ins-rule-validation-msg {\n        margin-top: -0.125rem;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-textarea__control monaco-editor {\n        border-radius: 0.25rem;\n        width: 100%;\n        height: 3rem;\n        max-height: 3rem;\n        padding: 0;\n        position: absolute;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-textarea__control monaco-editor>.monaco-editor {\n        border-radius: 0.25rem;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element .vloc-ins-rule-textarea__control monaco-editor>.monaco-editor>.overflow-guard {\n        border-radius: 0.25rem;\n        padding: 0.25rem 0;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element.slds-has-error .vloc-ins-rule-form-element__label {\n        color: #c23934;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-form-element.slds-has-error .vloc-ins-rule-validation-msg {\n        display: block;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-delete-rule-container .slds-button {\n        position: absolute;\n        top: 1.5rem;\n        right: 0;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-delete-warning-wrapper {\n        position: absolute;\n        top: 0;\n        right: 0;\n        height: 100%;\n        width: 80%;\n        z-index: -1;\n        background-color: #f4f6f9;\n        transition: z-index 0ms linear 300ms;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-delete-warning-wrapper .vloc-ins-rule-delete-warning-footer {\n        position: absolute;\n        bottom: 0;\n        right: 0;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-delete-warning-wrapper.delete-warning-active {\n        z-index: 1;\n        transition: z-index 0ms linear 0ms;\n    }\n\n    .via-slds ins-rules .vloc-ins-rules-container .vloc-ins-rule-add {\n        color: #00a1df;\n        font-style: italic;\n        margin-top: 0.5rem;\n        padding: 0 0.25rem;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder:after {\n        content: "";\n        display: table;\n        clear: both;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-6 {\n        display: none;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-3+.col-xs-3 {\n        display: none;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-9 {\n        width: 60%;\n        margin-right: 2%;\n        float: left;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-9 textarea {\n        width: 100%;\n        height: 6rem;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-9+.col-xs-3 {\n        width: 37%;\n        float: right;\n    }\n\n    .via-slds ins-rules .simpleExpressionBuilder>.col-xs-9+.col-xs-3 .slds-select[multiple] option {\n        padding: 0.25rem 0.5rem;\n        font-size: 0.75rem;\n    }\n\n    .via-slds ins-rules .has-error .slds-textarea {\n        background-color: #fff;\n        border-color: #c23934;\n        box-shadow: #c23934 0 0 0 1px inset;\n        background-clip: padding-box;\n    }\n\n    .via-slds ins-rules .has-error .help-block {\n        color: #c23934;\n    }\n\n    .via-slds ins-rules.small-width-container .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper {\n        padding: 0.75rem 0.75rem 0.75rem 0;\n    }\n\n    .via-slds ins-rules.small-width-container .vloc-ins-rules-container .vloc-ins-rule .vloc-ins-rule-inner-wrapper .vloc-ins-rule-number span {\n        font-size: 0.75rem;\n        width: 1.25rem;\n        height: 1.25rem;\n        line-height: 1.25rem;\n    }\n\n    .via-slds ins-rules.small-width-container .vloc-ins-rules-container .vloc-ins-rule:first-of-type .vloc-ins-rule-inner-wrapper {\n        padding-top: 0;\n    }\n\n    .via-slds ins-rules.small-width-container .simpleExpressionBuilder .vloc-ins-rule-insert-operator {\n        width: 40%;\n        flex: 0 0 40%;\n        max-width: 40%;\n    }\n\n    mentio-menu {\n        z-index: 9999 !important;\n    }\n\n    mentio-menu .vlocity.via-slds {\n        border: 1px solid #d8dde6;\n        border-radius: 0.25rem;\n        padding: 0.125rem 0;\n        background-color: white;\n        box-shadow: 1px 1px 10px 0 rgba(0, 0, 0, 0.35);\n        max-height: 15rem;\n        overflow-y: auto;\n        padding-bottom: 2.25rem;\n    }\n\n    mentio-menu .vlocity.via-slds:after {\n        content: "";\n        display: block;\n        position: absolute;\n        bottom: 0;\n        left: 0;\n        width: 100%;\n        height: 2.25rem;\n        z-index: 10;\n        background: linear-gradient(to bottom, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.6) 30%, rgba(255, 255, 255, 0.9) 70%, white 100%);\n    }\n\n    mentio-menu .vlocity.via-slds li {\n        padding: 0.5rem 0.75rem;\n        border-bottom: 1px solid #d8dde6;\n    }\n\n    mentio-menu .vlocity.via-slds li:last-child {\n        border-bottom: none;\n    }\n\n    mentio-menu .vlocity.via-slds li.active {\n        background-color: #f4f6f9;\n    }\n\n    mentio-menu .vlocity.via-slds li a:hover {\n        text-decoration: none;\n    }\n</style>')}]);
},{}]},{},[2]);

})();