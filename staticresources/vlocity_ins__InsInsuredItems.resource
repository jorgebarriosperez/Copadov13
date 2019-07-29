(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var partsLength=parts.length-1;var thisScript=parts[partsLength--];if(thisScript===""){thisScript=parts[partsLength--]}if(scriptName.indexOf("__")!=-1){while(thisScript.indexOf("__")==-1&&partsLength>=0){thisScript=parts[partsLength];partsLength--}}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
angular.module('insInsuredItems', ['vlocity', 'dndLists', 'CardFramework', 'sldsangular', 'forceng',
    'ngSanitize', 'cfp.hotkeys', 'insProductAttributes', 'insValidationHandler', 'insRules', 'insFormulaBuilder'
    ]).config(['remoteActionsProvider', function(remoteActionsProvider) {
        'use strict';
        remoteActionsProvider.setRemoteActions(window.remoteActions || {});
    }]).config(['$compileProvider', function ($compileProvider) {
        $compileProvider.debugInfoEnabled(true);
    }]).run(['$rootScope', function($rootScope) {
        'use strict';
        $rootScope.nsPrefix = fileNsPrefix();
        $rootScope.isLoaded = false;
        $rootScope.setLoaded = function(boolean) {
            $rootScope.isLoaded = boolean;
        };
        $rootScope.notification = {
            message: '',
            type: '',
            active: false
        };
    }]).filter('sldsStaticResourceURL', ['$rootScope', function($rootScope) {
        'use strict';
        return function(sldsURL) {
            return $rootScope.staticResourceURL.slds + sldsURL;
        };
    }]);

// Controllers
require('./modules/insInsuredItems/controller/InsInsuredItemsController.js');

// Templates
require('./modules/insInsuredItems/templates/templates.js');

// Factories
require('./modules/insInsuredItems/factory/InsProductSelectionModalService.js');
require('./modules/insInsuredItems/factory/InsCoveragesModelService.js');
require('./modules/insInsuredItems/factory/NotificationHandler.js');
require('./modules/insInsuredItems/factory/InsModalService.js');

// Directives
require('./modules/insInsuredItems/directive/HideNotification.js');




},{"./modules/insInsuredItems/controller/InsInsuredItemsController.js":2,"./modules/insInsuredItems/directive/HideNotification.js":3,"./modules/insInsuredItems/factory/InsCoveragesModelService.js":4,"./modules/insInsuredItems/factory/InsModalService.js":5,"./modules/insInsuredItems/factory/InsProductSelectionModalService.js":6,"./modules/insInsuredItems/factory/NotificationHandler.js":7,"./modules/insInsuredItems/templates/templates.js":8}],2:[function(require,module,exports){
angular.module('insInsuredItems').controller('InsInsuredItemsController', ['$scope', '$rootScope', 'InsValidationHandlerService', 'InsProductSelectionModalService', 'InsCoveragesModelService', 'InsModalService', 'NotificationHandler', '$timeout', function(
    $scope, $rootScope, InsValidationHandlerService, InsProductSelectionModalService, InsCoveragesModelService, InsModalService, NotificationHandler, $timeout) {
    'use strict';
    $scope.insFn = {};
    $scope.insVar = {};
    $scope.notificationHandler = new NotificationHandler();
    $rootScope.config = {
        attr: null,
        show: false
    };

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

    $scope.models = {
        selected: null,
        dropzones: {
            "list": $scope.insVar.items
        }
    };

    $rootScope.refreshCoverages = function(){
        let message = {
            event: 'reload'
        };
        $rootScope.$broadcast('vlocity.layout.ins-coverage-container.events', message);
    }; 

    $scope.insFn.setAttr = function(attr, objId) {
        if (attr[$rootScope.nsPrefix + 'IsConfigurable__c']) {
            if (!$rootScope.config.attr || (attr.Id !== $rootScope.config.attr.Id)) {
                $rootScope.isLoaded = false;
                if (objId) {
                    attr.coverageId = objId;
                }
                if (attr[$rootScope.nsPrefix + 'RuleData__c']) {
                    attr.rules = JSON.parse(attr[$rootScope.nsPrefix + 'RuleData__c']);
                }
                if ((typeof attr[$rootScope.nsPrefix + 'ValidValuesData__c']) === 'string') {
                    var parsed = JSON.parse(attr[$rootScope.nsPrefix + 'ValidValuesData__c']);
                    attr[$rootScope.nsPrefix + 'ValidValuesData__c'] = parsed;
                    if (attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Multi Picklist') {
                        attr[$rootScope.nsPrefix + 'Value__c'] = JSON.parse(attr[$rootScope.nsPrefix + 'Value__c']);
                    }
                }
                $rootScope.config.attr = attr;
                $rootScope.config.show = true;
                $rootScope.isLoaded = true;
            }
        }
    };

    var deleteRulesCoverage = function(obj) {
        let inputMap = {
            pciId: obj.Id,
            isOptional: obj.IsOptional,
            eligibilityRule: null,
            requiredRule: null, 
            defaultSelectedRule: null,
            overriddenAttributeAssignmentList: []
        };
        InsCoveragesModelService.saveCoverages($scope, inputMap).then(function(result) {
        }, function(error) {

        });
    };

    $scope.insFn.changeOptional = function(obj) {
        if (!obj.IsOptional) {
            obj.HasRules = false;
            deleteRulesCoverage(obj);
        }
    };



    var vlocInsert = function(array, index, item) {
        array.splice(index, 0, item);
    };

    var assignLineNumbers = function(a) {
        $scope.insVar.obj = [];
        for (var i = 0; i < a.length; i++) {
            if (a[i]) {
                $scope.insVar.obj.push(a[i]);
            }
        }
        InsCoveragesModelService.reorderChildItems($scope, $scope.insVar.obj, 'coverage');
    };

    $scope.insFn.filter = function(name) {
        if (name) {
            name = name.toLowerCase();
        }
        if ($rootScope.searchTerm && $rootScope.searchTerm !== '') {
            var searchTerm = $rootScope.searchTerm.toLowerCase();
            if (name.includes(searchTerm)) {
                return true;
            } else {
                return false;
            }
        }
        return true;
    };

      $scope.filterMap = {};

      $scope.insFn.filterCoverages = function(item) {
        let name = item.Name;
        if (name) {
            name = name.toLowerCase();
        }
        if ($rootScope.searchTerm && $rootScope.searchTerm !== '') {
            let searchTerm = $rootScope.searchTerm.toLowerCase();
            if (name.includes(searchTerm)) {
                $scope.filterMap[item.ChildProductId] = true;
                return true;
            } else {
                $scope.filterMap[item.ChildProductId] = false;
                return false;
            }
        }
        $scope.filterMap[item.ChildProductId] = true;
        return true;
    };


    $scope.insFn.setItems = function(obj) {
        var data, item, key, j, k, i, a, hierarchy;
        hierarchy = {};
        a = [];
        for (var key in obj) {
            item = obj[key];
            item.Id = key;
            item.id = obj[key].LineNumber;
            data = item.AttributeAssignmentList;
            if (data) {
                item.categories = {};
                organizeAttrData(data, item);
            }
            if (item.parentSpecId) {
                if (!hierarchy[item.parentSpecId]) {
                    hierarchy[item.parentSpecId] = [];
                }
                hierarchy[item.parentSpecId].push([item]);
            } else {
                a.push(item);
            }
        }
        $scope.insVar.items = setHierarchy(a, hierarchy);
        if ($scope.insVar.items.length) {
            setLineNumber();
        }
        $scope.models.dropzones.list = $scope.insVar.items;
        $rootScope.isLoaded = true;
    };

    //Organize Attribute Data For Card
    var organizeAttrData = function(data, item) {
        for (var i = 0; i < data.length; i++) {
            var category = data[i][$rootScope.nsPrefix + 'CategoryName__c'];
            if (data[i][$rootScope.nsPrefix + 'RuleData__c']) {
                data[i].rules = JSON.parse(data[i][$rootScope.nsPrefix + 'RuleData__c']);
            }
            if (!item.categories[category]) {
                var lst = [data[i]];
                item.categories[category] = lst;
            } else {
                item.categories[category].push(data[i]);
            }
        }
    };

    //Set hierarchy by ChildProdcutId
    var setHierarchy = function(a, hierarchy) {
        for (var i = 0; i < a.length; i++) {
            if (hierarchy[a[i].ChildProductId]) {
                a[i].columns = hierarchy[a[i].ChildProductId];
            } else {
                a[i].columns = [
                    []
                ];
            }
        }
        return a;
    }

    //Order Parents by linenumber
    var setLineNumber = function() {
        var i, a, item;
        a = new Array(Object.keys($scope.insVar.items).length - 1);
        for (i = 0; i < $scope.insVar.items.length; i++) {
            item = $scope.insVar.items[i];
            if (!a[item.LineNumber]) {
                a[item.LineNumber] = item;
            } else {
                vlocInsert(a, item.LineNumber, item);
            }
        }
        $scope.insVar.items = [];
        for (i = 0; i < a.length; i++) {
            if (a[i] && a[i].Id) {
                $scope.insVar.items.push(a[i]);
            }
        }
        for (i = 0; i < $scope.insVar.items.length; i++) {
            if ($scope.insVar.items[i]) {
                $scope.insVar.items[i].LineNumber = i + 1;
            }
        }
    };

    $scope.insFn.setData = function(data) {
        if (data) {
            var a = new Array(Object.keys(data).length - 1);
            for (var key in data) {
                var item = data[key];
                if(!item.parentSpecId){
                  item.parentSpecId = $rootScope.productId;
                }
                if(item.EligibilityCriteria || item.DefaultSelectedCriteria || item.RequiredCriteria || item.selectValidationCriteria){
                  item.HasRules = true;
                }
                item.Id = key;
                if (!a[item.LineNumber]) {
                    a[item.LineNumber] = item;
                } else {
                    vlocInsert(a, item.LineNumber, item);
                }
            }
            assignLineNumbers(a);
        }
    };

    $scope.insFn.updateJSON = function() {
        console.log('update json for product');
        InsCoveragesModelService.saveCoverageJSON($scope);
    };

    $scope.insFn.launchModal = function() {
        console.log('launching from service');
        InsCoveragesModelService.launchNewAttrModal($scope, 'getInsuredItemsForAddition');
    };

    $scope.insFn.launchRelationshipModal = function() {
        console.log('launching from service');
        const modalData = {};
        InsProductSelectionModalService.launchModal(
          $scope,
          'ins-coverage-dependent-opt-modal',
          modalData,
          'InsInsuredItemsController',
          'ins-coverage-dependent-opt-modal',
          'Optional Coverage Relationships'
        );
    };

    $scope.insFn.getInsuredItems = function(){
      console.log('get associated insured items');
      InsCoveragesModelService.getAssociatedInsuredItems($scope);
    }

    $scope.insFn.launchCoverageModal = function() {
        console.log('launching from service');
        InsCoveragesModelService.launchNewAttrModal($scope, 'getCoveragesForAddition');
    };

    $scope.insFn.launchPorpertiesModal = function() {
        InsCoveragesModelService.launchNewAttrModal($scope, 'getClaimPropertiesForAddition');
    };

    $scope.insFn.launchInjuriesModal = function() {
        InsCoveragesModelService.launchNewAttrModal($scope, 'getClaimInjuriesForAddition');
    };

    $scope.insFn.launchRatingFactModal = function() {
        InsCoveragesModelService.launchNewAttrModal($scope, 'getRatingFactsForAddition');
    };

    $scope.$on('refresh_insured_items', function (event, data) {
        if($scope.insVar.items){
            InsCoveragesModelService.getAssociatedInsuredItems($scope, 'insuredItems');
            $timeout(function() {
                $scope.insFn.setItems($scope.insVar.items);
            }, 1000);
        }
    });

    $scope.insFn.addItems = function(records, type) {
        var inputMap = {
            productId: $rootScope.productId
        };
        var lst = [];
        for (var key in records) {
            console.log(records[key]);
            if (records[key].isSelected) {
                lst.push(key);
            }
        }

        if (type === 'claimProperties' && lst.length > 0) {
            console.log('add claimProperties');
            inputMap.claimProperties = lst;
            InsCoveragesModelService.addItems($scope, inputMap, 'claimProperties');
        }

        if (type === 'claimInjuries' && lst.length > 0) {
            console.log('add claimInjuries');
            inputMap.claimInjuries = lst;
            InsCoveragesModelService.addItems($scope, inputMap, 'claimInjuries');
        }

        if (type === 'insuredItems' && lst.length > 0) {
            console.log('add insured items');
            inputMap.insuredItemIds = lst;
            InsCoveragesModelService.addItems($scope, inputMap, 'insuredItems');
        }
        if (type === 'coverages' && lst.length > 0) {
            console.log('add coverages');
            inputMap.coverageIds = lst;
            InsCoveragesModelService.addItems($scope, inputMap, 'coverage');
        }
        if (type === 'ratingFacts' && lst.length > 0) {
            console.log('add rating facts');
            inputMap.ratingFacts = lst;
            InsCoveragesModelService.addItems($scope, inputMap, 'ratingFacts');
        }
    };

    $scope.insFn.deleteInsuredItem = function(id) {
        console.log('deleteInsuredItem');
        InsCoveragesModelService.deleteItem($scope, id, 'deleteInsuredItem', 'insuredItems');
    };

    $scope.insFn.deleteClaimInjury = function(id) {
        console.log('deleteClaimInjury');
        InsCoveragesModelService.deleteItem($scope, id, 'deleteInvolvedInjury', 'claimInjuries');
    };

    $scope.insFn.deleteClaimProperty = function(id) {
        console.log('deleteClaimProperty');
        InsCoveragesModelService.deleteItem($scope, id, 'deleteInvolvedProperty', 'claimProperties');
    };

    $scope.insFn.deleteRatingFact = function(id) {
        console.log('deleteRatingFact');
        InsCoveragesModelService.deleteItem($scope, id, 'deleteRatingFact', 'ratingFacts');
    }

    $scope.insFn.saveItem = function(id, isOptional, attrs, minQuantity, maxQuantity, typeObj) {
        console.log('save: ' + typeObj);
        var input = [];
        var type, temp;
        if (attrs) {
            for (var i = 0; i < attrs.length; i++) {
                temp = Object.assign({}, attrs[i]);
                if (!temp[$rootScope.nsPrefix + 'IsRatingAttribute__c']) {
                    temp[$rootScope.nsPrefix + 'RatingInput__c'] = null;
                    temp[$rootScope.nsPrefix + 'RatingOutput__c'] = null;
                }
                if(temp[$scope.nsPrefix + 'RatingType__c'] === 'Output'){
                     temp[$scope.nsPrefix + 'RatingInput__c'] = null; 
                 } 
                if(temp[$scope.nsPrefix + 'RatingType__c'] === 'Input'){
                     temp[$scope.nsPrefix + 'RatingOutput__c'] = null;
                }
                let saveRules = temp.rules;
                if (saveRules) {
                    if (saveRules.validation) {
                        delete saveRules.validation;
                    }
                    let saveRulesStr = JSON.stringify(saveRules);
                    temp[$scope.nsPrefix + 'RuleData__c'] = saveRulesStr;
                    temp[$scope.nsPrefix + 'HasRule__c'] = true;
                }
                for (var key in temp) {
                    type = typeof(temp[key]);
                    if (type === 'object' || type === 'number') {
                        if(temp[key] !== null){
                            temp[key] = JSON.stringify(temp[key]);
                        }
                    }
                    if ((key === $rootScope.nsPrefix + 'Value__c') && type === 'boolean') {
                        temp[key] = JSON.stringify(temp[key]);
                    }
                }
                input.push(temp);
            }
        }
        var inputMap = {
            pciId: id,
            isOptional: isOptional,
            overriddenAttributeAssignmentList: input
        };
        if (typeObj === 'coverage') {
            InsCoveragesModelService.saveCoverages($scope, inputMap);
        } else {
            inputMap.minQuantity = minQuantity;
            inputMap.maxQuantity = maxQuantity;
            if (typeObj === 'insuredItem') {
                InsCoveragesModelService.saveInsuredItem($scope, inputMap);
            }
            if (typeObj === 'ratingFacts') {
                InsCoveragesModelService.saveRatingFact($scope, inputMap);
            }
            if (typeObj === 'claimInjuries') {
                InsCoveragesModelService.saveClaimInjuries($scope, inputMap);
            }
            if (typeObj === 'claimProperties') {
                InsCoveragesModelService.saveClaimProperties($scope, inputMap);
            }
        }
    };

    $scope.insFn.deleteCoverage = function(id, index) {
        console.log('deleteCoverage');
        InsCoveragesModelService.deleteItem($scope, id, 'deleteCoverage', 'coverage');
    };

    $scope.insFn.updateMin = function(min) {
        return min + 1;
    };

    $scope.reorderSequences = function(index) {
        var i, target;
        var item = $scope.insVar.obj[index];
        $scope.insVar.obj.splice(index, 1);
        for (i = 0; i < $scope.insVar.obj.length; i++) {
            if ($scope.insVar.obj[i].Id === item.Id) {
                target = i;
            }
        }
        if (target > index) {
            $scope.insVar.obj[target] = $scope.insVar.obj[target + 1];
            $scope.insVar.obj[target + 1] = item;
        }
        for (i = 0; i < $scope.insVar.obj.length; i++) {
            $scope.insVar.obj[i].LineNumber = i;
        }
        $rootScope.dragging = false;
        InsCoveragesModelService.reorderChildItems($scope, $scope.insVar.obj, 'coverage');
    };
    $scope.reorderSequencesInsuredItem = function(index, list) {
        $rootScope.dragging = false;
        $rootScope.isLoading = true;
        var i, target, error;
        var item = list[index];
        var inputMap = {
            childPciIds: [item.Id]
        };
        if (!item.columns) {
            inputMap.childPciIds = [item.Id];
            inputMap.parentSpecId = null;
            item.parentSpecId = null;
        }
        list.splice(index, 1);
        for (i = 0; i < $scope.insVar.items.length; i++) {
            if (item.Id && $scope.insVar.items[i] && $scope.insVar.items[i].Id === item.Id) {
                target = i;
            }
            if ($scope.insVar.items[i].columns) {
                for (var j = 0; j < $scope.insVar.items[i].columns[0].length; j++) {
                    if ($scope.insVar.items[i].columns[0][j].Id === item.Id) {
                        if ($scope.insVar.items[i].columns[0][j].columns && $scope.insVar.items[i].columns[0][j].columns.length > 1) {
                            error = 'Cannot Associate a Parent with Children to a Parent';
                            InsValidationHandlerService.throwError(error);
                            $scope.notificationHandler.hide();
                        } else {
                            inputMap.parentSpecId = $scope.insVar.items[i].ChildProductId;
                        }
                    }
                }
            }
        }
        if (target > index) {
            $scope.insVar.items[target] = $scope.insVar.items[target + 1];
            $scope.insVar.items[target + 1] = item;
        }
        for (i = 0; i < $scope.insVar.items.length; i++) {
            if (!$scope.insVar.items[i]) {
                $scope.insVar.items.splice(i, 1);
            }
        }
        for (i = 0; i < $scope.insVar.items.length; i++) {
            $scope.insVar.items[i].LineNumber = i + 1;
            if (!$scope.insVar.items[i].columns) {
                $scope.insVar.items[i].columns = [
                    []
                ];
            }
        }
        console.log('items', $scope.insVar.items);
        if(error){
          InsCoveragesModelService.linkChildSpecs($scope, inputMap, error);
        } else {
          InsCoveragesModelService.linkChildSpecs($scope, inputMap);
        }
        InsCoveragesModelService.reorderChildItems($scope, $scope.insVar.items, 'insuredItem');

    };

    $scope.linkChildSpecs = function (obj){
        let inputMap = {
            childPciIds: [obj.Id],
            parentSpecId: obj.parentSpecId
        };
        InsCoveragesModelService.linkChildSpecs($scope, inputMap);
    };

    $scope.startDragging = function(event) {
        $rootScope.dragging = true;
        var lastMouseEvent, config, viewportHeight, scrollY, structureCanvas;
        lastMouseEvent = null;
        config = {
            activationDistance: 30,
            scrollDistance: 5,
            scrollInterval: 15,
            newPageYOffset: window.pageYOffset
        };

        $timeout(function() {
            if (!lastMouseEvent) {
                return;
            }
            viewportHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
            scrollY = 0;
            if (lastMouseEvent.clientY < config.activationDistance) {
                // If the mouse is on the top of the viewport within the activation distance.
                scrollY = -config.scrollDistance;
            } else if (lastMouseEvent.clientY > viewportHeight - config.activationDistance) {
                // If the mouse is on the bottom of the viewport within the activation distance.
                scrollY = config.scrollDistance;
            }
            structureCanvas = angular.element('.cards-container')[0];
            if (scrollY !== 0) {
                // console.log('structureCanvas.scrollHeight - viewportHeight', structureCanvas.scrollHeight - viewportHeight);
                // console.log('structureCanvas.scrollTop', structureCanvas.scrollTop);
                // console.log('config.newPageYOffset', config.newPageYOffset);
                if ((structureCanvas.scrollHeight - viewportHeight) <= structureCanvas.scrollTop) {
                    // console.log('Inside first');
                    config.newPageYOffset += scrollY;
                    // console.log('config.newPageYOffset', config.newPageYOffset);
                    window.scrollTo(0, config.newPageYOffset);
                } else {
                    // console.log('Inside second');
                    structureCanvas.scrollTop += scrollY;
                }
            }
        }, config.scrollInterval);
        lastMouseEvent = event;
        return true; // always return true because we can always drop here
    };


    $scope.insFn.showRules = function(id, isOptional, attrs, minQuantity, maxQuantity, typeObj) {
        if (!$rootScope.config.attr.rules) {
            $rootScope.config.attr.rules = [];
        }
        var records = {
            record: $rootScope.config.attr,
            rules: $rootScope.config.attr.rules,
            rulesOptions: $scope.rulesOptions
        };
        var originalRulesCopy = angular.copy($rootScope.config.attr.rules);
        InsModalService.launchModal(
            $scope,
            'ins-product-attributes-rules-modal',
            records,
            'InsProductAttributesController',
            'vloc-quote-modal',
            function() {
                if (($rootScope.config.attr.rules && originalRulesCopy && $rootScope.config.attr.rules.length > originalRulesCopy.length) || !angular.equals($rootScope.config.attr.rules, originalRulesCopy)) {
                    $scope.insFn.saveItem(id, isOptional, attrs, minQuantity, maxQuantity, typeObj);
                }
            }
        );
    };

    $scope.insFn.showRulesOption = function(row, obj) {
        if (!row.rules) {
            row.rules = [];
        }
        var records = {
            record: row.attr,
            rules: row.rules,
            rulesOptions: $scope.rulesOptions
        };
        var originalRulesCopy = angular.copy(row.rules);
        InsModalService.launchModal(
            $scope,
            'ins-product-attributes-rules-modal',
            records,
            'InsProductAttributesController',
            'vloc-quote-modal',
            function() {
                if ((row.rules && originalRulesCopy && row.rules.length > originalRulesCopy.length) || !angular.equals(row.rules, originalRulesCopy)) {
                    $scope.insFn.saveItem(obj.Id, obj.IsOptional, obj.AttributeAssignmentList, obj.MinQuantity, obj.MaxQuantity, 'insuredItem');
                }
            }
        );
    };

    $scope.searchFilter = function(name, term) {
        if (term !== '' && term !== undefined) {
            var temp = name.toLowerCase();
            term = term.toLowerCase();
            if (temp.indexOf(term) > -1) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    };

    $scope.orderMap = function(map) {
        console.log(map);
        let associationMap = {};
        for (var key in map) {   
          if(!associationMap[map[key].Name]){
            associationMap[map[key].Name] = map[key];
          } else {
            associationMap[map[key].Name + map[key].ProductCode] = map[key];
          }
        }
        $scope.sortedList = Object.values(associationMap);
    };

    $scope.formatDate = function(date) {
         if (moment) {
             var formattedDate = moment(date).utc().format('M/D/YYYY')
             return formattedDate;
         } else {
            var d = new Date(date);
            var formattedDate = (d.getUTCMonth() + 1) + '/' + d.getUTCDate() + '/' + d.getUTCFullYear();
        }
        return formattedDate;
    };

    $scope.formatDatetime = function(date) {
         if (moment) {
             var formattedDate = moment(date).utc().format('M/D/YYYY hh:mm')
             return formattedDate;
         } else {
            var d = new Date(date);
            var formattedDate = (d.getUTCMonth() + 1) + '/' + d.getUTCDate() + '/' + d.getUTCFullYear();
        }
        return formattedDate;
    };

    $scope.setOrderTerm = function(orderTerm) {
        if ($scope.orderTerm !== orderTerm) {
            $scope.orderAsc = true;
            $scope.orderTerm = orderTerm;
        } else {
            $scope.orderAsc = !$scope.orderAsc;
        }
    }

    $scope.initRelations = function(){
        $scope.relationships = [];
        let inputMap = {
            productId : $rootScope.productId
        };
        InsCoveragesModelService.getOptionalCoverages($scope, inputMap);
        InsCoveragesModelService.getProductRelationshipTypes($scope, inputMap);
        InsCoveragesModelService.getChildCoverageProductRelationships($scope, inputMap);
    };


    $scope.addRelationship = function() {
        console.log('addRelationship');
        const relationshipObj = {
            prodRelType: '',
            srcProdId: '',
            tgtProdId: '',
            newRule: true
        };
        $scope.relationships.push(relationshipObj);
        $timeout(function() {
            delete $scope.relationships[$scope.relationships.length - 1].newRule;
            resetUIToSlds(true);
        }, 100);
        console.log($scope.relationships);
    };

    const resetUIToSlds = function(scrollToBottom) {
        $timeout(function() {
            let modalEl = $('.vloc-modal-container .vloc-modal-content');
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
    };

      $scope.deletePrompt = function(relationship) {
          if (!relationship.inDelete) {
              angular.forEach($scope.relationships, function(relationship) {
                  relationship.inDelete = false;
              });
          }
          relationship.inDelete = !relationship.inDelete;
      };

      $scope.saveRelationship = function(relationship){
        console.log(relationship);
        relationship.tgtProdName = $scope.optcoveragesMap[relationship.tgtProdId];
        relationship.srcProdName = $scope.optcoveragesMap[relationship.srcProdId];
        relationship.prodRelLbl = $scope.relationshipTypesMap[relationship.prodRelType];
        if(relationship.srcProdId && relationship.tgtProdId && relationship.prodRelType){
            const inputMap = {
                productRelationships : $scope.relationships
            };
          InsCoveragesModelService.saveProductRelationships($scope, inputMap, relationship);
        }
      };

      $scope.deleteProductRelationships = function(relationship, index){ 
        $timeout(function() {
            relationship.inDelete = !relationship.inDelete;
            relationship.isDeleted = true;
            if(relationship.prodRelId){
                const inputMap = {
                    productRelationshipId : relationship.prodRelId
                };
                InsCoveragesModelService.deleteProductRelationships($scope, inputMap);
            }
        }, 250);
        $timeout(function() {
            relationship.isDeleted = false;
            $scope.relationships.splice(index, 1);
            console.log($scope.relationships);
        }, 900);
      };

      $scope.deleteRelationship = function(relationship, index) {
          relationship.inDelete = !relationship.inDelete;
          $timeout(function() {
              relationship.isDeleted = true;
          }, 250);
          $timeout(function() {
              relationship.isDeleted = false;
              $scope.relationships.splice(index, 1);
              console.log($scope.relationship);
          }, 900);
      };


}]);
},{}],3:[function(require,module,exports){
angular.module('insInsuredItems').directive('hideNotification', function($rootScope, $timeout) {
    'use strict';
    return {
        restrict: 'A',
        link: function() {
            $rootScope.$watch('notification.message', function(newValue) {
                // Only fire on notification with message. Notifications without a message
                // will be when it closes
                if (newValue !== '') {
                    $timeout(function() {
                        // After 3 seconds, closes notification on mousedown of anywhere in the
                        // document except the notification itself (X closes though):
                        $('body').on('touchstart mousedown', function(e) {
                            e.preventDefault();
                            $rootScope.log('target: ', e);
                            if (e.target.parentNode.className.indexOf('slds-notify') > -1) {
                                return;
                            }
                            // Clear out notification
                            $timeout(function() {
                                $rootScope.notification.message = '';
                            }, 500);
                            $rootScope.notification.active = false;
                            // Have to apply rootScope
                            $rootScope.$apply();
                            // Unbind mousedown event from whole document
                            $(this).off('touchstart mousedown');
                        });
                    }, 2000);
                }
            });
        }
    };
});

},{}],4:[function(require,module,exports){
angular.module('insInsuredItems').factory('InsCoveragesModelService', 
['$rootScope', '$sldsModal', '$timeout',  '$http', '$q', 'dataSourceService', 'dataService', 'InsProductSelectionModalService', 'InsValidationHandlerService',
function($rootScope, $sldsModal, $timeout,  $http, $q, dataSourceService, dataService, InsProductSelectionModalService, InsValidationHandlerService) {
    'use strict';
    const tabs = {
        insuredItems : 'vlocity.layout.ins-insured-items-container.events',
        claimInjuries :'vlocity.layout.ins-claims-injuries-admin-container.events',
        claimProperties : 'vlocity.layout.ins-claims-properties-admin-container.events',
        coverage : 'vlocity.layout.ins-coverage-container.events',
        ratingFacts : 'vlocity.layout.ins-rating-fact-container.events'
    }; 

    var refreshList = function(type) {
        if(type === 'insuredItems'){
            let message = {
                event: 'refreshInsuredItems',
            };
            $rootScope.$broadcast('refresh_insured_items', message);
            refreshTab('coverage');
        } else {
            let message = {
                event: 'reload'
            };
            $rootScope.$broadcast(tabs[type], message);
        }
    };
 
    function refreshTab(type){
        console.log('refreshTab');
        let obj =   {
            message: 'ltng:event',
            event: 'e.' + $rootScope.nsPrefix.replace('__', '') + ':vlocityCardEvent',
            params: {
                "layoutName": 'ins-coverage-container',
                "message" : {
                    event: 'reload'
                }
            }
        };
    if ('parentIFrame' in window) {   
      window.parentIFrame.sendMessage(obj);
    }
};
    var scrollTop = function(){
        if ('parentIFrame' in window) {
            window.parentIFrame.scrollTo(0);
        } else {
            $('body').scrollTop(0);
        }
    };
    
    return {
        launchNewAttrModal: function(scope, fn) {
            console.log('call modal with service', $rootScope.productId);
            $rootScope.isLoaded = false;
            scrollTop();
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            var inputMap = {'productId' : $rootScope.productId};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.inputMap = inputMap;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = fn;
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    if(fn === 'getCoveragesForAddition'){
                        modalData.records = data.coverages;
                        modalData.type = 'coverages';
                    } if (fn === 'getClaimInjuriesForAddition'){
                        console.log('claimData', data);
                        modalData.records = data.claimInjuries;
                        modalData.type = 'claimInjuries';
                    }
                    if (fn === 'getClaimPropertiesForAddition'){
                        console.log('claim properites', data);
                        modalData.records = data.claimProperties;
                        modalData.type = 'claimProperties';
                    }
                    if(fn === 'getInsuredItemsForAddition'){
                        modalData.records = data.insuredItems;
                        modalData.type = 'insuredItems';
                    }
                    if(fn === 'getRatingFactsForAddition'){
                        modalData.records = data.ratingFacts;
                        modalData.type = 'ratingFacts';
                    }
                    if(modalData){
                    InsProductSelectionModalService.launchModal(
                          scope,
                          'ins-coverage-attr-modal',
                          modalData,
                          'InsInsuredItemsController',
                          'ins-coverage-attr-modal'
                      );
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    InsValidationHandlerService.throwError(error);
                });
           return  deferred.promise;
        }, saveCoverages: function(scope, inputMap) {
            console.log('call modal with service', $rootScope.productId);
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveCoverage';
            datasource.value.inputMap = inputMap;
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    refreshList('coverage');
                    $rootScope.isLoaded = true;
                    var message = 'Updated Coverage Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleSuccess(error);
                    scope.notificationHandler.hide();
                });
           return  deferred.promise;
        }, addItems: function(scope, inputMap, type) {
            $rootScope.isLoaded = false;
            var fn = '';
            console.log('call add Items with', scope);
            if(type === 'insuredItems'){
                fn = 'addInsuredItems';
            } 
            if(type === 'claimProperties'){
                fn = 'addClaimProperties';
            } if (type === 'claimInjuries'){
                fn = 'addClaimInjuries';
            }
            if (type === 'coverage'){
                fn = 'addCoverages';
            }
            if (type === 'ratingFacts'){
                fn = 'addRatingFact';
            }
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = fn;
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {    
                    console.log(data);
                    deferred.resolve(data);
                    refreshList(type);
                    var message = 'Added Items Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    $timeout(function() {
                        InsProductSelectionModalService.hideModal();
                    }, 250);
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    InsValidationHandlerService.throwError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, saveInsuredItem: function(scope, inputMap) {
            $rootScope.isLoaded = false;
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveInsuredItem';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    var message = 'Updated Item Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList('insuredItems');
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise; 
        }, saveClaimInjuries: function(scope, inputMap) {
            $rootScope.isLoaded = false;
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveClaimInjury';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    var message = 'Updated Item Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList('claimInjuries');
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },saveClaimProperties: function(scope, inputMap) {
            $rootScope.isLoaded = false;
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveClaimProperty';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    var message = 'Updated Item Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList('claimProperties');
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, saveRatingFact: function(scope, inputMap) {
            $rootScope.isLoaded = false;
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveRatingFact';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    var message = 'Updated Item Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList('ratingFacts');
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },
         deleteItem: function(scope, id, fn, type) {
            $rootScope.isLoaded = false;
            console.log('record', id);
            var inputMap  = {
              pciId : id
            };
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = fn;
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    refreshList(type);
                    var message = 'Deleted Item Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },
        reorderChildItems: function(scope, obj, type){
            $rootScope.isLoaded = false;
            var inputMap  = {};
            inputMap.childItems = {};
            for(var i = 0; i <  obj.length; i++){
                if(obj[i]){
                    inputMap.childItems[obj[i].Id] =  obj[i];
                }
            }
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'reorderChildItems';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, saveCoverageJSON: function(scope){
            $rootScope.isLoaded = false;
            var inputMap  = {
              productId : $rootScope.productId
            };
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveCoverageJSON';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    refreshList('coverage');
                    var message = 'Successfully Updated JSON for Product';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, linkChildSpecs: function(scope, inputMap, error){
            $rootScope.isLoaded = false;
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'linkChildSpecs';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    refreshList('insuredItems'); 
                    if(!error){
                        var message = 'Successfully Updated Insured Items';
                        scope.notificationHandler.handleSuccess(message);
                        scope.notificationHandler.hide();
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },  getAssociatedInsuredItems: function(scope, type){
            $rootScope.isLoaded = false;
            var inputMap  = {
              productId : $rootScope.productId
            };
            var modalData = {};
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getAssociatedInsuredItems';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    if(type === 'insuredItems'){
                        $rootScope.isLoaded = false;
                        console.log('refresh');
                        scope.insVar.items = data.insuredItems;
                    }
                    else {
                        let a =  Object.values(data.insuredItems);
                        let rootProd = {
                            ChildProductId : $rootScope.productId, 
                            Name: 'None'
                        }; 
                        scope.insuredItems = [rootProd];
                        for(let i = 0; i < a.length; i++){
                            if(!a[i].parentSpecId || a[i].parentSpecId === $rootScope.productId){
                                 scope.insuredItems.push(a[i]);
                            }
                        }
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, getChildCoverageProductRelationships: function(scope, inputMap, error){
            $rootScope.isLoaded = false;
            const deferred = $q.defer();
            const nsPrefix = fileNsPrefix().replace('__', '');
            const datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getChildCoverageProductRelationships';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    scope.relationships = data.result;
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, getProductRelationshipTypes: function(scope, inputMap, error){
            $rootScope.isLoaded = false;
            const deferred = $q.defer();
            const nsPrefix = fileNsPrefix().replace('__', '');
            const datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getProductRelationshipTypes';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    scope.relationshipTypes = data.result;
                    scope.relationshipTypesMap = {};
                    for(let i = 0; i < scope.relationshipTypes.length; i++){
                        if(scope.relationshipTypes[i]){
                              scope.relationshipTypesMap[scope.relationshipTypes[i].prodRelType] = scope.relationshipTypes[i].prodRelLbl;
                        }
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },getOptionalCoverages: function(scope, inputMap, error){
            $rootScope.isLoaded = false;
            const deferred = $q.defer();
            const nsPrefix = fileNsPrefix().replace('__', '');
            const datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getOptionalCoverages';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    scope.optcoverags = data.result;
                    scope.optcoveragesMap = {};
                    for(let i = 0; i < scope.optcoverags.length; i++){
                        if(scope.optcoverags[i]){
                              scope.optcoveragesMap[scope.optcoverags[i].covProdId] = scope.optcoverags[i].covProdName;
                        }
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        },saveProductRelationships: function(scope, inputMap, relationship){
            $rootScope.isLoaded = false;
            const deferred = $q.defer();
            const nsPrefix = fileNsPrefix().replace('__', '');
            const datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveProductRelationships';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    if(data.result && data.result.productRelationships){
                        for(let i = 0; i < data.result.productRelationships.length; i++){
                            if(data.result.productRelationships[i].srcProdId === relationship.srcProdId && 
                                data.result.productRelationships[i].tgtProdId === relationship.tgtProdId ){
                                relationship.prodRelId =   data.result.productRelationships[i].prodRelId;
                            }
                        }
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
        }, deleteProductRelationships: function(scope, inputMap, error){
            $rootScope.isLoaded = false;
            const deferred = $q.defer();
            const nsPrefix = fileNsPrefix().replace('__', '');
            const datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.inputMap = inputMap;
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'deleteProductRelationships';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
           return  deferred.promise;
       }
    };
}]);
},{}],5:[function(require,module,exports){
angular.module('insInsuredItems').factory('InsModalService',
['$rootScope', '$sldsModal', '$timeout',
function($rootScope, $sldsModal, $timeout) {
    'use strict';
    
     var scrollTop = function(){
        if ('parentIFrame' in window) {
            window.parentIFrame.scrollTo(0);
        } else {
            $('body').scrollTop(0);
        }
    };

    return {
        launchModal: function(scope, layout, records, ctrl, customClass, onHide) {
            var modalScope = scope.$new();
            var insModal;
            scrollTop();
            modalScope.vlocQuote = scope.vlocQuote;
            modalScope.isLayoutLoaded = false;
            modalScope.layout = layout;
            modalScope.records = records;
            modalScope.ctrl = ctrl;
            modalScope.title = 'Attribute Rules';
            modalScope.customClass = customClass;
            insModal = $sldsModal({
                scope: modalScope,
                templateUrl: 'modals/ins-quote-modal.tpl.html',
                show: true,
                vlocSlide: true,
                onHide: onHide
            });
            // generate click on the modal to get insDropdownHandler directive to work:
            // $timeout(function() {
            //     angular.element('.slds-modal__content').click();
            // }, 500);
        },
        hideModal : function(){
            angular.element('.slds-modal__close').click();
        }
    };
}]);

},{}],6:[function(require,module,exports){
angular.module('insInsuredItems').factory('InsProductSelectionModalService', 
['$rootScope', '$sldsModal', '$timeout',
function($rootScope, $sldsModal, $timeout) {
    'use strict';
    return {
        launchModal: function(scope, layout, records, ctrl, customClass, title) {
            let modalScope = scope.$new();
            let insModal;
            modalScope.title = title;
            modalScope.isLayoutLoaded = false;
            modalScope.layout = layout;
            modalScope.records = records;
            console.log('modalScope.records', modalScope.records );
            modalScope.ctrl = ctrl;
            modalScope.customClass = customClass;
            insModal = $sldsModal({
                scope: modalScope,
                templateUrl: 'modals/ins-product-selection-modal.tpl.html',
                show: true,
                vlocSlide: true, // Added by Robert Henderson CORE-1077
                vlocSlideCustomClass: customClass, // Added by Robert Henderson CORE-1077
                vlocSlideHeader: true, // Added by Robert Henderson CORE-1077
                vlocSlideFooter: false // Added by Robert Henderson CORE-1077
            });
            // generate click on the modal to get insDropdownHandler directive to work:
            $timeout(function() {
                angular.element('.slds-modal__content').click();
            }, 500);
            modalScope.hideModal = function() {
                $timeout(function() {
                    insModal.hide();
                }, 500);
            };
        },
        hideModal : function(){
            angular.element('.slds-modal__close').click();
        }
    };
}]);
},{}],7:[function(require,module,exports){
angular.module('insInsuredItems').factory('NotificationHandler', 
    ['$rootScope','$timeout', function($rootScope, $timeout) {
    'use strict';
    var NotificationHandler = function() {
        this.initialize = function() {

        };
        this.handleError = function(error) {
            $rootScope.notification.message = error.data.message || error.data.error;
            $rootScope.notification.type = 'error';
            $rootScope.notification.active = true;
        }; 

        this.handleSuccess = function(message) {
            console.log('message', message);
            $rootScope.notification.message = message;
            $rootScope.notification.type = 'success';
            $rootScope.notification.active = true;
        };

        this.hide = function(){
            $timeout(function() {
                $rootScope.notification.active = false;
            }, 3000);
        };

        this.initialize();
    };
    return (NotificationHandler);
}]);
},{}],8:[function(require,module,exports){
angular.module("insInsuredItems").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ins-insured-item-body.tpl.html",'<div  class="slds-m-bottom_small slds-p-top_small vloc-box slds-small-show via-slds-card__body slds-grid slds-grid_vertical" ng-class="{\'isChild\' : !item.columns, \'slds-box\' : importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]}">\n   <div class="slds-grid vloc-card-header slds-p-left_small slds-p-right_small slds-p-top_small slds-p-bottom_small" ng-class="{\'dragging\' : $root.dragging}" ng-show="importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]">\n      <div class="slds-media slds-media_center slds-has-flexi-truncate">\n         <div class="slds-media__figure">\n            <vloc-card-icon data="data" item="item" size="\'medium\'"></vloc-card-icon>\n         </div>\n         <div class="slds-media__body slds-truncate">\n            <a href="javascript:void(0);" class="slds-text-link_reset" tooltip-placement="bottom" tooltip="{{data.title}}">\n            <span class="slds-text-heading_small" ng-click="importedScope.insFn.navTo(item.Id)"> {{item.Name}}</span>\n            </a><span class="vloc-italic" ng-if="item.ProductCode">({{item.ProductCode}})</span>\n         </div>\n      </div>\n      <div class="slds-no-flex slds-text-align_right">\n         <div>\n            <label class="slds-text-heading_label slds-p-right_medium">Cardinality</label>\n         </div>\n         <div class="slds-text-align_right">\n            <input class="slds-input slds-size_1-of-6" type="number" min="0" ng-model="item.MinQuantity"/><span> - </span>\n            <input class="slds-input slds-size_1-of-6" type="number" min="item.MinQuantity - 1" ng-model="item.MaxQuantity"/>\n         </div>\n      </div>\n   </div>\n   <div class="vloc-card-body slds-theme_default"  ng-class="{\'dragging\' : $root.dragging}" ng-show="importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]">\n      <!--Atributes: --> \n      <div class="vloc-attr-grid slds-p-top_x-small slds-theme_default slds-p-left_small slds-p-right_small">\n         <div class="vloc-attr-row slds-row slds-p-bottom_medium" data-card="card-{{cardIndex}}" data-popover-flyout="true" ng-repeat="(category, attributes) in item.categories">\n            <div class="vloc-attr-category-heading slds-text-heading_small slds-m-left_xx-small slds-p-bottom_small" ng-click="categories.show = !categories.show">\n               <slds-button-svg-icon sprite="\'utility\'" icon="\'chevronright\'" ng-if="!categories.show" extra-classes="vloc-attrs-category-btn"></slds-button-svg-icon>\n               <slds-button-svg-icon sprite="\'utility\'" icon="\'chevrondown\'" ng-if="categories.show" extra-classes="vloc-attrs-category-btn"></slds-button-svg-icon>\n               {{category}}\n            </div>\n            <div class="slds-col slds-grid slds-wrap slds-grid_align-spread" ng-repeat="row in attributes" ng-if="categories.show">\n               <div class="slds-small-show vloc-attr-cell slds-size_1-of-{{data.fields.length}}" ng-repeat="field in data.fields" ng-show="key != \'attributes\'">\n                  <div class="slds-text-title_caps slds-small-show vloc-attr-cell slds-truncate slds-size_1-of-1 slds-p-around_xx-small slds-m-horizontal_xx-small" ng-if="$parent.$index === 0 && field.name !== $root.nsPrefix + \'RatingType__c\' && field.name !== $root.nsPrefix + \'RatingInput__c\' && field.name !== $root.nsPrefix + \'RatingOutput__c\' ">\n                     {{field.label}}\n                  </div>\n                  <div class="slds-text-title_caps slds-small-show vloc-attr-cell slds-truncate slds-size_1-of-1 slds-p-around_xx-small slds-m-horizontal_xx-small" ng-if="row[$root.nsPrefix + \'IsRatingAttribute__c\'] && (field.name === $root.nsPrefix + \'RatingType__c\' || (row[$root.nsPrefix + \'RatingType__c\'] === \'Input\' && field.name ===  $root.nsPrefix + \'RatingInput__c\' ) || (row[$root.nsPrefix + \'RatingType__c\'] === \'Output\' && field.name ===  $root.nsPrefix + \'RatingOutput__c\'))">\n                     {{field.label}} \n                  </div>\n                  <div class="vloc-attr-data-cell slds-truncate slds-p-around_xx-small slds-m-horizontal_xx-small">\n                     <div class="slds-select_container slds-m-right_small slds-size_1-of-1"  ng-if="row[$root.nsPrefix + \'IsRatingAttribute__c\'] &&  field.name === $root.nsPrefix + \'RatingType__c\'" ng-init="picklistOptions = [\'Input\', \'Output\']">\n                        <select ng-disabled="$root.productRecordType === \'RatingFactSpec\'" ng-options="opts for opts in picklistOptions" class="slds-select slds-m-right_xx-small slds-truncate" ng-model="row[field.name]">\n                        </select>\n                     </div>\n                     <span ng-if="field.name !== $root.nsPrefix + \'RatingType__c\' && field.name !== $root.nsPrefix + \'IsRatingAttribute__c\' && field.name !==  $root.nsPrefix + \'RatingInput__c\' && field.name !==  $root.nsPrefix + \'RatingOutput__c\' && field.name !== $root.nsPrefix + \'HasRules__c\'">\n                        <span ng-if="field.label !== \'Value\' && field.type !== \'BOOLEAN\'"> \n                        {{row | getter: field | picker: field.type}}</span>\n                        <span ng-if="field.label === \'Value\'"> \n                        <span ng-if="row.valueType !== \'percent\'"> {{row | getter: field | picker: row.valueType}}</span>\n                        <span ng-if="row.valueType === \'percent\'"> {{row[$root.nsPrefix + \'Value__c\']}}%</span>\n                        </span>\n                        <div class="slds-form-element__control slds-text-align_left" ng-if="field.type === \'BOOLEAN\'">\n                           <span class="slds-checkbox">\n                           <input type="checkbox" name="attrs-{{$parent.$index}}" id="attrs-{{$parent.$index}}" ng-model="row[field.name]" />\n                           <label class="slds-checkbox__label slds-m-around_none" for="attrs-{{$parent.$index}}">\n                           <span class="slds-checkbox_faux vloc-check"></span>\n                           </label>\n                           </span>\n                        </div>\n                     </span>\n                     <div class="slds-form-element__control slds-text-align_left vloc-attrs-checkbox" ng-if="field.type === \'BOOLEAN\' || field.type === \'boolean\'">\n                        <span class="slds-checkbox">\n                        <input type="checkbox" name="config-attrs-{{row.Id}}" id="config-attrs-{{row.Id}}" ng-model="row[field.name]"/>\n                        <label class="slds-checkbox__label slds-m-around_none" for="config-attrs-{{row.Id}}">\n                        <span class="slds-checkbox_faux vloc-check"></span>\n                        </label>\n                        </span>\n                     </div>\n                     <span ng-if="row[$root.nsPrefix + \'IsRatingAttribute__c\'] && (row[$root.nsPrefix + \'RatingType__c\'] === \'Input\' && field.name ===  $root.nsPrefix + \'RatingInput__c\' ) || (row[$root.nsPrefix + \'RatingType__c\'] === \'Output\' && field.name ===  $root.nsPrefix + \'RatingOutput__c\')">\n                        <input class="slds-input vloc-attrs-input" type="{row.dataType}}" ng-model="row[field.name]" ng-if="field.type !== \'BOOLEAN\' && field.type !== \'boolean\'"/>\n                        <div class="slds-form-element__control slds-text-align_left vloc-attrs-checkbox" ng-if="field.type === \'BOOLEAN\' || field.type === \'boolean\'">\n                           <span class="slds-checkbox">\n                           <input type="checkbox" name="config-attrs-{{row.Id}}" id="config-attrs-{{row.Id}}" ng-model="row[field.name]"/>\n                           <label class="slds-checkbox__label slds-m-around_none" for="config-attrs-{{row.Id}}">\n                           <span class="slds-checkbox_faux vloc-check"></span>\n                           </label>\n                           </span>\n                        </div>\n                     </span>\n                     <span class="vloc-rules-icon slds-text-align_center" ng-if="field.name === $root.nsPrefix + \'HasRules__c\'" ng-click="importedScope.insFn.showRulesOption(row, item)" ng-class="{\'has-rules\': row.rules.length > 0}">\n                        <slds-button-svg-icon sprite="\'custom\'" icon="\'custom90\'" no-hint="true" extra-classes="\'slds-button__icon_large\'"></slds-button-svg-icon>\n                     </span>\n                  </div>\n               </div>\n            </div>\n         </div>\n      </div>\n   </div>\n   <div ng-class="{\'dragging\' : $root.dragging}" class="row " ng-repeat="list in item.columns" ng-include="\'list.html\'"></div>\n   <div ng-show="importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]" class="slds-theme_default vloc-border-radius vloc-card-body" ng-class="{\'dragging\' : $root.dragging}">\n      <button class="slds-button slds-button_link slds-m-horizontal_medium slds-p-horziontal_medium" ng-click="importedScope.insFn.saveItem(item.Id, item.IsOptional, item.AttributeAssignmentList, item.MinQuantity,  item.MaxQuantity, \'insuredItem\')">Save</button>\n      <button class="slds-button slds-button_link  slds-m-horizontal_medium slds-p-horizontal_medium" ng-click="importedScope.insFn.deleteInsuredItem(item.Id)">Remove</button>\n   </div>\n   <div class="embed-flyout slds-p-left_medium slds-p-right_medium"></div>\n   <div ng-show="importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]"class="slds-x-small-show-only via-slds-x-small-card__body slds-card__body slds-grid slds-grid_vertical slds-theme_default" ng-if="!$root.dragging">\n      <div class="slds-size_1-of-1 slds-x-small-show-only" ng-repeat="field in data.fields.slice(1, 6)" ng-show="key != \'attributes\'">\n         <div class="slds-grid via-slds-grid slds-p-around_small">\n            <div class="slds-col slds-size_1-of-2">\n               <p class="slds-text-align_left slds-truncate slds-text-heading_label" title="{{field.label}}">{{field.label}}&nbsp;</p>\n            </div>\n            <div class="slds-col slds-size_1-of-2" ng-if="!item[field.relationshipName]">\n               <p class="slds-text-align_right slds-truncate" >{{item | getter: field | picker: field.type}}&nbsp;</p>\n            </div>\n            <div class="slds-col slds-size_1-of-2" ng-if="item[field.relationshipName]">\n               <p class="slds-text-align_right slds-truncate" >{{item[field.relationshipName][\'Name\']}}&nbsp;</p>\n            </div>\n         </div>\n      </div>\n   </div>\n   <div ng-show="importedScope.insFn.filterCoverages(item) || importedScope.filterMap[item.parentSpecId]" class="slds-card__footer slds-x-small-show-only slds-theme_default" ng-if="!$root.dragging">\n      <button class="slds-button" ng-click="performFlyout(uniqueLayoutId + \'-card-\'+ cardIndex);">\n      <span ng-if="!isSelected(cardIndex)">{{::$root.vlocity.getCustomLabel(\'ViewMore\', \'View More\')}}</span>\n      <span ng-if="isSelected(cardIndex)">{{::$root.vlocity.getCustomLabel(\'ViewLess\', \'View Less\')}}</span>\n      </button>\n   </div>\n</div>'),$templateCache.put("modals/ins-product-selection-modal.tpl.html",'<div class="slds-modal slds-fade-in-open slds-modal_medium vloc-modal vloc-modal-slds-slide-up {{vlocSlideCustomClass}}" ng-init="isModalLoaded = !isModalLoaded">\n    <div class="slds-modal__container vloc-modal-container {{vlocSlideCustomClass}}-container">\n        <button class="slds-button slds-button_icon-inverse slds-modal__close vloc-align-{{vlocSlideMobileClose}}" ng-click="$slideHide()" ng-if="!vlocSlideHeader">\n            <slds-button-svg-icon sprite="\'action\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n            <span class="slds-assistive-text">Close</span>\n        </button>\n        <header class="slds-modal__header slds-is-relative" ng-show="vlocSlideHeader">\n            <button class="slds-button slds-button_icon-inverse slds-modal__close vloc-align-{{vlocSlideMobileClose}}" ng-click="$slideHide()">\n                <slds-button-svg-icon sprite="\'action\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Close</span>\n            </button>\n            <h2 ng-show="title" class="slds-text-heading_medium slds-hyphenate" ng-bind="title"></h2>\n        </header>\n        <div class="slds-modal__content vloc-modal-content slds-is-relative">\n            <div class="slds-spinner_container" ng-class="{\'vloc-show-loader\': !isModalLoaded}">\n                <div class="slds-spinner_brand slds-spinner slds-spinner_large slds-m-top_x-large slds-m-bottom_x-large" aria-hidden="false" role="alert">\n                    <div class="slds-spinner__dot-a"></div>\n                    <div class="slds-spinner__dot-b"></div>\n                </div>\n            </div>\n              <vloc-layout layout-name="{{layout}}" class="{{layout}}" is-loaded="isLayoutLoaded" records="records" ctrl="{{ctrl}}"></vloc-layout>\n        </div>\n        <footer class="slds-modal__footer" ng-show="vlocSlideFooter">\n            <button class="slds-button slds-button_neutral" ng-click="$slideHide()">Cancel</button>\n        </footer>\n    </div>\n</div>\n<style type="text/css">\n    .vlocity.via-slds .vloc-modal.slds-modal {\n        top: -100%;\n        margin-bottom: 45px;\n        height: auto;\n        transition: top 250ms ease-in;\n        position: absolute;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-spinner_container {\n        opacity: 0;\n        visibility: hidden;\n        transition: visibility 0ms linear 1250ms,\n                    opacity 500ms ease-in 750ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-spinner_container.vloc-show-loader {\n        opacity: 1;\n        visibility: visible;\n        transition: visibility 0ms linear 0ms,\n                    opacity 500ms ease-in 0ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-global-header_container {\n        opacity: 0;\n        transition: opacity 200ms ease-in 200ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal.vloc-modal-shown {\n        top: 45px;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal.vloc-modal-shown\n    .slds-global-header_container {\n        opacity: 1;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-edit-insured-item-modal {\n        position: absolute;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-modal-container {\n        height: auto;\n        max-height: 35rem;\n        width: 90%;\n        min-width: 90%;\n        max-width: 90%;\n        padding: 0;\n        margin: 1rem 0 0;\n        position: absolute;\n        left: 50%;\n        transform: translateX(-50%);\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-modal-container\n    .vloc-modal-content {\n        min-height: 20rem;\n        border-radius: 0;\n        margin-bottom: 2.5rem;\n    }\n\n    @media screen and (max-width: 600px) {\n        .vlocity.via-slds .vloc-modal.slds-modal {\n            height: calc(100% - 20px); /* leaving room for iPhone notification bar */\n        }\n\n        .vlocity.via-slds.platform-android .vloc-modal.slds-modal {\n            height: 100%; /* Android doesn\'t need the 20px of room like iPhone */\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__header {\n            border-radius: 0;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close {\n            top: 0.5rem;\n            left: auto;\n            right: auto;\n            z-index: 999;\n            color: #00396B;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close.vloc-align-left {\n            left: 0.5rem;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close.vloc-align-right {\n            right: 0.5rem;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .vloc-modal-container {\n            width: 100%;\n            min-width: 100%;\n            height: 100%;\n            top: 0;\n            left: 0;\n            transform: none;\n            bottom: 0;\n            transition: bottom 250ms ease-in;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .vloc-modal-container\n        .vloc-modal-content {\n            height: 100%;\n            min-height: auto;\n            max-height: 100%;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__footer {\n            border-radius: 0;\n        }\n    }\n</style>')}]);
},{}]},{},[1]);

})();