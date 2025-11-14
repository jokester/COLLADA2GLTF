build: .PHONY
	rm -rf build && mkdir -pv build && cd build && cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && make -j

.PHONY:
