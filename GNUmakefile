build: .PHONY
	rm -rf build && mkdir -pv build && cd build && cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_C_FLAGS="-DHAVE_UNISTD_H" && nice make -j8

patch:
	patch -p1 < patch.diff

.PHONY:
