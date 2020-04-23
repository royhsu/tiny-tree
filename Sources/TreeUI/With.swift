//
//  With.swift
//  
//
//  Created by Roy Hsu on 2020/4/17.
//

func withObject<Object: AnyObject>(
  _ object: Object,
  configuration: (Object) -> Void
) -> Object {
  configuration(object)
  return object
}
