VerticalAlignment);
	}
	IMPLEMENT_CLASS(UGridSlot, 72147285);
	void UHorizontalBoxSlot::StaticRegisterNativesUHorizontalBoxSlot()
	{
		FNativeFunctionRegistrar::RegisterFunction(UHorizontalBoxSlot::StaticClass(), "SetHorizontalAlignment",(Native)&UHorizontalBoxSlot::execSetHorizontalAlignment);
		FNativeFunctionRegistrar::RegisterFunction(UHorizontalBoxSlot::StaticClass(), "SetPadding",(Native)&UHorizontalBoxSlot::execSetPadding);
		FNativeFunctionRegistrar::RegisterFunction(UHorizontalBoxSlot::StaticClass(), "SetSize",(Native)&UHorizontalBoxSlot::execSetSize);
		FNativeFunctionRegistrar::RegisterFunction(UHorizontalBoxSlot::StaticClass(), "SetVerticalAlignment",(Native)&UHorizontalBoxSlot::execSetVerticalAlignment);
	}
	IMPLEMENT_CLASS(UHorizontalBoxSlot, 3486100519);
	void UOverlaySlot::StaticRegisterNativesUOverlaySlot()
	{
		FNativeFunctionRegistrar::RegisterFunction(UOverlaySlot::StaticClass(), "SetHorizontalAlignment",(Native)&UOverlaySlot::execSetHorizontalAlignment);
		FNativeFunctionRegistrar::RegisterFunction(UOverlaySlot::StaticClass(), "SetPadding",(Native)&UOverlaySlot::execSetPadding);
		FNativeFunctionRegistrar::RegisterFunction(UOverlaySlot::StaticClass(), "SetVerticalAlignment",(Native)&UOverlaySlot::execSetVerticalAlignment);
	}
	IMPLEMENT_CLASS(UOverlaySlot, 4137262039);
	void USafeZoneSlot::StaticRegisterNativesUSafeZoneSlot()
	{
	}
	IMPLEMENT_CLASS(USafeZoneSlot, 1154580096);
	void UScaleBoxSlot::StaticRegisterNativesUScaleBoxSlot()
	{
		FNativeFunctionRegistrar::RegisterFunction(UScaleBoxSlot::StaticClass(), "SetHorizontalAlignment",(Native)&UScaleBoxSlot::execSetHorizontalAlignment);
		FNativeFunctionRegistrar::RegisterFunction(UScaleBoxSlot::StaticClass(), "SetPadding",(Native)&UScaleBoxSlot::execSetPadding);
		FNativeFunctionRegistrar::RegisterFunction(UScaleBoxSlot::StaticClass(), "SetVerticalAlignment",(Native)&UScaleBoxSlot: