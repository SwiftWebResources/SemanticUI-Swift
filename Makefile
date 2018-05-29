# Makefile

SWIFT_RESOURCE_SCRIPT = ./rsrc2swift.sh

PACKAGE_NAME=SemanticUI

SemanticUI_RESOURCE_FILES = \
	$(wildcard Upstream/*.min.css) \
	$(wildcard Upstream/*.min.js)  \
	$(wildcard Upstream/components/*.min.css) \
	$(wildcard Upstream/components/*.min.js)  \
	$(wildcard Upstream/themes/default/assets/fonts/*.eot)   \
	$(wildcard Upstream/themes/default/assets/fonts/*.svg)   \
	$(wildcard Upstream/themes/default/assets/fonts/*.ttf)   \
	$(wildcard Upstream/themes/default/assets/fonts/*.otf)   \
	$(wildcard Upstream/themes/default/assets/fonts/*.woff)  \
	$(wildcard Upstream/themes/default/assets/fonts/*.woff2) \
	$(wildcard Upstream/themes/default/assets/images/*.png)  \

all : package-as-swift
	swift build

clean :
	swift package clean
	rm -f Sources/$(PACKAGE_NAME)/ResourceMap.swift \
	      Sources/$(PACKAGE_NAME)/Resources.swift

distclean : clean
	rm -rf .build Package.resolved

package-as-swift : Sources/$(PACKAGE_NAME)/ResourceMap.swift \
		   Sources/$(PACKAGE_NAME)/Resources.swift

Sources/$(PACKAGE_NAME)/Resources.swift: $($(PACKAGE_NAME)_RESOURCE_FILES) Makefile
	@echo "// Generated on `date`" > $@
	@echo "//" >> $@
	@echo "" >> $@
	@echo "import struct Foundation.Data" >> $@
	@echo >> $@
	@echo "public enum $(PACKAGE_NAME) {" >> $@
	@for file in $($(PACKAGE_NAME)_RESOURCE_FILES); do \
	  tfile=$$(mktemp /tmp/foo.XXXXXXXXX); \
	  $(SWIFT_RESOURCE_SCRIPT) $$file $$tfile; \
	  cat $$tfile >> $@; \
	  rm $$tfile; \
	done
	@echo "}" >> $@
	
Sources/$(PACKAGE_NAME)/ResourceMap.swift: $($(PACKAGE_NAME)_RESOURCE_FILES) Makefile
	@echo "// Generated on `date`" > $@
	@echo "//" >> $@
	@echo >> $@
	@echo "import struct Foundation.Data" >> $@
	@echo >> $@
	@echo "public extension $(PACKAGE_NAME) {" >> $@
	@echo >> $@
	@echo "  /**" >> $@
	@echo "   * Lookup a $(PACKAGE_NAME) resource. The returned Data" >> $@
	@echo "   * contains the gzip compressed resource." >> $@
	@echo "   *" >> $@
	@echo "   * Available resource names:" >> $@
	@echo "   *" >> $@
	@for file in $($(PACKAGE_NAME)_RESOURCE_FILES); do \
	  origname="`echo $$file | sed 's|Upstream/||'`"; \
	  nicename="`basename $$file | sed 's/\\./_/g' | sed 's/\\-/_/g'`"; \
	  echo "   * - \"$${origname}\"" >> $@; \
	done
	@echo "   *" >> $@
	@echo "   */" >> $@
	@echo "  public static func resourceNamed(_ name: String) -> Data? {" >> $@
	@echo "    switch name {" >> $@
	@echo >> $@;
	@for file in $($(PACKAGE_NAME)_RESOURCE_FILES); do \
	  origname="`echo $$file | sed 's|Upstream/||'`"; \
	  nicename="`basename $$file | sed 's/\\./_/g' | sed 's/\\-/_/g'`"; \
	  echo "      case \"$${origname}\":" >> $@; \
	  echo "        return data_$${nicename}" >> $@; \
	  echo >> $@; \
	done
	@echo "      default: return nil" >> $@
	@echo "    }" >> $@
	@echo "  }" >> $@
	@echo "}" >> $@
